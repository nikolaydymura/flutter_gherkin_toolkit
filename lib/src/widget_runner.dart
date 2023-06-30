import 'package:gherkin/gherkin.dart';
import 'package:gherkin/src/gherkin/parser.dart';
import 'package:gherkin/src/gherkin/runnables/feature_file.dart';
import 'package:test/test.dart';

import '../flutter_gherkin_toolkit.dart';

class WidgetRunner {
  final _reporter = AggregatedReporter();
  final _hook = AggregatedHook();
  final _parser = GherkinParser();
  final _languageService = LanguageService();
  final _tagExpressionEvaluator = TagExpressionEvaluator();
  final List<ExecutableStep> _executableSteps = <ExecutableStep>[];
  final List<CustomParameter> _customParameters = <CustomParameter>[];

  Future<void> execute(TestConfiguration testConfiguration) async {
    final config = testConfiguration.prepare();
    _registerReporters(config.reporters);
    _registerHooks(config.hooks);
    _registerCustomParameters(config.customStepParameterDefinitions);
    _registerStepDefinitions(config.stepDefinitions);
    _languageService.initialise(config.featureDefaultLanguage);

    List<FeatureFile> featureFiles = await _getFeatureFiles(config);
    if (config.order == ExecutionOrder.random) {
      await _reporter.message(
        'Executing features in random order',
        MessageLevel.info,
      );
      featureFiles = featureFiles.toList()..shuffle();
    } else if (config.order == ExecutionOrder.alphabetical) {
      await _reporter.message(
        'Executing features in sorted order',
        MessageLevel.info,
      );
      featureFiles.sort(
            (FeatureFile a, FeatureFile b) => a.name.compareTo(b.name),
      );
    }
    setUpAll(()  async {
      await _hook.onBeforeRun(config);
      await _reporter.test.onStarted.invoke();
    });

    for (final featureFile in featureFiles) {
      for (final feature in featureFile.features) {
        groupFeature(feature, config, _tagExpressionEvaluator, _executableSteps, _reporter, _hook,);
      }
    }

    tearDownAll(()  async {
      await _reporter.test.onFinished.invoke();
      await _hook.onAfterRun(config);
      await _reporter.dispose();
    });
  }

  Future<List<FeatureFile>> _getFeatureFiles(TestConfiguration config) async {
    try {
      final featureFiles = <FeatureFile>[];

      for (final pattern in config.features) {
        final paths = await config.featureFileMatcher.listFiles(pattern);

        for (final path in paths) {
          await _reporter.message(
            "Found feature file '$path'",
            MessageLevel.verbose,
          );

          final contents = await config.featureFileReader.read(path);
          final featureFile = await _parser.parseFeatureFile(
            contents,
            path,
            _reporter,
            _languageService,
          );

          featureFiles.add(featureFile);
        }
      }

      if (featureFiles.isEmpty) {
        await _reporter.message(
          'No feature files found to run, exiting without running any scenarios',
          MessageLevel.warning,
        );
      } else {
        await _reporter.message(
          'Found ${featureFiles.length} feature file(s) to run',
          MessageLevel.info,
        );
      }

      return featureFiles;
    } catch (e) {
      throw Exception(
        'Error when trying to find feature files with patterns'
            '${config.features.map((e) => e.toString()).join(', ')}`'
            'ERROR: `${e.toString()}`',
      );
    }
  }

  void _registerStepDefinitions(
      Iterable<StepDefinitionGeneric>? stepDefinitions,
      ) {
    if (stepDefinitions != null) {
      for (final s in stepDefinitions) {
        _executableSteps.add(
          ExecutableStep(
            GherkinExpression(
              s.pattern is RegExp
                  ? s.pattern as RegExp
                  : RegExp(s.pattern.toString()),
              _customParameters,
            ),
            s,
          ),
        );
      }
    }
  }

  void _registerCustomParameters(Iterable<CustomParameter>? customParameters) {
    _customParameters.add(FloatParameterLower());
    _customParameters.add(FloatParameterCamel());
    _customParameters.add(NumParameterLower());
    _customParameters.add(NumParameterCamel());
    _customParameters.add(IntParameterLower());
    _customParameters.add(IntParameterCamel());
    _customParameters.add(StringParameterLower());
    _customParameters.add(StringParameterCamel());
    _customParameters.add(WordParameterLower());
    _customParameters.add(WordParameterCamel());
    _customParameters.add(PluralParameter());

    if (customParameters != null) {
      _customParameters.addAll(customParameters);
    }
  }

  void _registerReporters(Iterable<Reporter>? reporters) {
    if (reporters != null) {
      for (final r in reporters) {
        _reporter.addReporter(r);
      }
    }
  }

  void _registerHooks(Iterable<Hook>? hooks) {
    if (hooks != null) {
      _hook.addHooks(hooks);
    }
  }
}