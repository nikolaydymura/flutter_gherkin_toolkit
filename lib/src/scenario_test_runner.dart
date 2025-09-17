import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import '../flutter_amazing_test.dart';

class ScenarioTestRunner {
  ScenarioTestRunner({
    this.variantsFilter,
    this.featuresFilter,
    this.scenarioFilter,
  });

  final Set<DeviceConfiguration> Function(Set<DeviceConfiguration>)?
      variantsFilter;
  final List<File> Function(List<File>)? featuresFilter;
  final bool Function(ScenarioEntry)? scenarioFilter;

  Future<void> run({
    required Widget Function(String, DeviceConfiguration) bootBuilder,
    dynamic Function()? setUpOverride,
    dynamic Function()? tearDownOverride,
    dynamic Function(SocketEntry)? onStep,
    FutureOr<void> Function(ScenarioEntry)? setUpScenario,
  }) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final variants = ValueVariant<DeviceConfiguration>(await loadVariants());
    final scenariosFiles = await loadScenarios();

    for (final scenarioPath in scenariosFiles) {
      final scenariosContent = await File(scenarioPath.path).readAsString();
      late final dynamic feature;
      if (scenarioPath.path.endsWith('.yaml') ||scenarioPath.path.endsWith('.yml') ){
        try {
          feature = loadYaml(scenariosContent);
        } catch (e) {
          throw Exception('Error parsing YAML in file ${scenarioPath.path}: $e');
        }
      }
      if (scenarioPath.path.endsWith('.json'))  {
        try {
          feature = jsonDecode(scenariosContent);
        } catch (e) {
          throw Exception('Error parsing JSON in file ${scenarioPath.path}: $e');
        }
      }
      final Iterable<ScenarioEntry> scenarios = feature['scenarios']
          .map((e) => ScenarioEntry.fromConfiguration(e))
          .whereType<ScenarioEntry>()
          .where((e) => scenarioFilter?.call(e) ?? true)
          .toList();
      final skipGroup = feature['skip'] ?? false;
      group(
        feature['description'],
        () {
          setUp(setUpOverride ?? () {});

          tearDown(tearDownOverride ?? () {});

          for (final scenario in scenarios) {
            screenTest(
              scenario.description,
              setUp: () => setUpScenario?.call(scenario),
              bootBuilder: (variant) =>
                  bootBuilder.call(scenario.screen, variant),
              skip: scenario.skip ?? skipGroup,
              variant: variants,
              (tester) async {
                await _consumeSteps(tester, variants, scenario, onStep);
              },
            );
          }
        },
        skip: skipGroup,
      );
    }
  }

  Future<Set<DeviceConfiguration>> loadVariants() async {
    final basedir = (goldenFileComparator as LocalFileComparator).basedir;

    final variantsFile = File(
      path.join(
        path.fromUri(basedir),
        'variants.json',
      ),
    );
    final variantsJson = await variantsFile.readAsString();
    final variants = (jsonDecode(variantsJson) as List)
        .map((e) => DeviceConfiguration.fromJson(e))
        .whereType<DeviceConfiguration>()
        .toSet();
    return variantsFilter?.call(variants) ?? variants;
  }

  Future<List<File>> loadScenarios() async {
    final basedir = (goldenFileComparator as LocalFileComparator).basedir;

    final scenarios = Directory(
      path.join(
        path.fromUri(basedir),
        'scenarios',
      ),
    ).listSync(recursive: true).whereType<File>().toList();
    return featuresFilter?.call(scenarios) ?? scenarios;
  }
}

Future<void> _consumeSteps(
  WidgetTester tester,
  ValueVariant<DeviceConfiguration> variants,
  ScenarioEntry scenario,
  dynamic Function(SocketEntry)? onStep,
) async {
  for (final step in scenario.steps) {
    final options = step.split(' ');
    final action = options.first;
    if (action == 'WAIT') {
      final Duration duration;
      if (options.length > 1) {
        duration = Duration(milliseconds: int.parse(options[1]));
      } else {
        duration = const Duration(milliseconds: 100);
      }
      await tester.runAsync(() => Future.delayed(duration));
      await tester.pump(duration);
      await tester.pumpAndSettle(duration);
    } else if (action == 'CAPTURE') {
      final golden = path.join(
        'screenshots',
        '${options[1]}+${variants.currentValue}.png',
      );
      await expectLater(
        find.byWidgetPredicate((w) => true).first,
        matchesGoldenFile(
          golden,
        ),
      );
    } else if (action == 'TAP') {
      if (step.contains(' TEXT ')) {
        await tester.tap(find.textStep(step));
      } else if (step.contains(' KEY ')) {
        final dragWidget = find.keyStep(step);
        await tester.tap(dragWidget);
      }
    } else if (action == 'TYPE') {
      final textOptions = RegExp(r'''TYPE ['"`](.*)['"`]''').firstMatch(step)?.group(1);
      if (textOptions == null || textOptions.isEmpty) {
        throw Exception('Text not found in step: $step');
      }
      var finder = find.keyStep(step);
      await tester.enterText(finder, textOptions);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
    } else if (action == 'DRAG') {
      final x = double.parse(
        options
                .firstWhereOrNull((e) => e.startsWith('X='))
                ?.split('=')
                .lastOrNull ??
            '0.0',
      );
      final y = double.parse(
        options
                .firstWhereOrNull((e) => e.startsWith('Y='))
                ?.split('=')
                .lastOrNull ??
            '0.0',
      );
      final dragWidget = find.keyStep(step);
      await tester.tap(dragWidget);
    } else if (action == 'SCROLL') {
      final x = double.parse(
        options
                .firstWhereOrNull((e) => e.startsWith('X='))
                ?.split('=')
                .lastOrNull ??
            '0.0',
      );
      final y = double.parse(
        options
                .firstWhereOrNull((e) => e.startsWith('Y='))
                ?.split('=')
                .lastOrNull ??
            '0.0',
      );
      await tester.fling(
        find.byType(Scrollable).first,
        Offset(
          x,
          y,
        ),
        1000.0,
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
    } else if (action == 'ON') {
      final body = options.skip(1).join(' ');
      onStep?.call(SocketEntry.fromConfiguration(body));
    }
  }
}

extension on CommonFinders {
  static final textOptions = RegExp(r'''TEXT ['"`](.*)['"`]''');
  static final keyOptions = RegExp(r'KEY\s+(\S+)\s*');
  static final positionOptions = RegExp(r'AT (first|last|\d+)');

  Finder textStep(String step) {
    final text = textOptions.firstMatch(step)?.group(1);
    if (text == null || text.isEmpty) {
      throw Exception('Text not found in step: $step');
    }
    final position = positionOptions.firstMatch(step)?.group(1);
    if (position == 'first') {
      return find.textContaining(text).first;
    } else if (position == 'last') {
      return find.textContaining(text).last;
    } else if (position != null) {
      final index = int.tryParse(position);
      if (index != null) {
        return find.textContaining(text).at(index);
      }
    }
    return find.textContaining(text);
  }

  Finder keyStep(String step) {
    final key = keyOptions.firstMatch(step)?.group(1);
    if (key == null || key.isEmpty) {
      throw Exception('Key not found in step: $step');
    }
    final position = positionOptions.firstMatch(step)?.group(1);
    if (position == 'first') {
      return find.byKey(Key(key)).first;
    } else if (position == 'last') {
      return find.byKey(Key(key)).last;
    } else if (position != null) {
      final index = int.tryParse(position);
      if (index != null) {
        return find.byKey(Key(key)).at(index);
      }
    }
    return find.byKey(Key(key));
  }
}
