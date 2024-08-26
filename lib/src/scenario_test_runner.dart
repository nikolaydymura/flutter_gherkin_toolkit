import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

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
    FutureOr<void> Function(ScenarioEntry)? setUpScenario,
  }) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final variants = ValueVariant<DeviceConfiguration>(await loadVariants());
    final scenariosFiles = await loadScenarios();

    for (final scenarioPath in scenariosFiles) {
      final scenariosContent = await File(scenarioPath.path).readAsString();
      final feature = jsonDecode(scenariosContent);
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
                await _consumeSteps(tester, variants, scenario);
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
        find.byType(MaterialApp),
        matchesGoldenFile(
          golden,
        ),
      );
    } else if (action == 'TAP') {
      if (step.contains('TEXT')) {
        final textOptions = step.split('TEXT ');
        final textAction = textOptions.last;
        var finder = find.text(textAction);
        await tester.tap(finder);
      }
    } else if (action == 'TYPE') {
      final keyOptions = step.split('in KEY ');
      final textOptions = keyOptions.first.split('TYPE ').last.trim();
      final keyAction = keyOptions.last;
      var finder = find.byKey(Key(keyAction));
      await tester.enterText(finder, textOptions);
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
    }
  }
}
