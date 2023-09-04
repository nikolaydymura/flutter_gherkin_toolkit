import 'utils/exports.dart';
import 'package:gherkin/gherkin.dart';
import 'package:meta/meta.dart';


import 'worlds/widget_tester_world.dart';

@isTestGroup
void groupFeature(
    FeatureRunnable feature,
    TestConfiguration config,
    TagExpressionEvaluator tagExpressionEvaluator,
    Iterable<ExecutableStep> steps,
    FullReporter reporter,
    Hook hook,
    {dynamic skip,
    VoidCallback? body}) {
  return group(feature.name, () {
    setUp(() async {
      await reporter.feature.onStarted.invoke(
        FeatureMessage(
          name: feature.name,
          description: feature.description,
          context: feature.debug,
          tags: feature.tags.isEmpty
              ? []
              : feature.tags
                  .map(
                    (t) => t.tags
                        .map(
                          (c) => Tag(
                            c,
                            t.debug.lineNumber,
                            isInherited: t.isInherited,
                          ),
                        )
                        .toList(),
                  )
                  .reduce((a, b) => a..addAll(b))
                  .toList(),
        ),
      );
      await _log(
        reporter,
        "Attempting to running feature '${feature.name}'",
        feature.debug,
        MessageLevel.info,
      );
    });
    tearDown(() async {
      await reporter.feature.onFinished.invoke(
        FeatureMessage(
          name: feature.name,
          description: feature.description,
          context: feature.debug,
        ),
      );
      await _log(
        reporter,
        "Finished running feature '${feature.name}'",
        feature.debug,
        MessageLevel.info,
      );
    });
    for (final scenario in feature.scenarios) {
      testScenarioWidgets(scenario, (widgetTester) async {},
          config: config,
          tagExpressionEvaluator: tagExpressionEvaluator,
          steps: steps,
          reporter: reporter,
          hook: hook);
    }
  });
}

@isTest
void testScenarioWidgets(
  ScenarioRunnable scenario,
  WidgetTesterCallback callback, {
  required TestConfiguration config,
  required TagExpressionEvaluator tagExpressionEvaluator,
  required Iterable<ExecutableStep> steps,
  required FullReporter reporter,
  required Hook hook,
  bool? skip,
  TestVariant<Object?> variant = const DefaultTestVariant(),
}) {
  return testWidgets(
    scenario.name,
    (widgetTester) async {
      final attachmentManager = await config.getAttachmentManager(config);
      late final WidgetTesterWorld world;
      var scenarioPassed = true;
      final tags = scenario.tags.isNotEmpty
          ? scenario.tags
              .map(
                (t) => t.tags
                    .map(
                      (tag) => Tag(
                        tag,
                        t.debug.lineNumber,
                        isInherited: t.isInherited,
                      ),
                    )
                    .toList(),
              )
              .reduce((a, b) => a..addAll(b))
              .toList()
          : const Iterable<Tag>.empty();

      try {
        await _log(
          reporter,
          "Creating new world for scenario '${scenario.name}'",
          scenario.debug,
          MessageLevel.debug,
        );
        world = WidgetTesterWorld(widgetTester);

        world.setAttachmentManager(attachmentManager);
        await hook.onAfterScenarioWorldCreated(
          world,
          scenario.name,
          tags,
        );

        await hook.onBeforeScenario(config, scenario.name, tags);

        await reporter.scenario.onStarted.invoke(
          ScenarioMessage(
            target: scenario.scenarioType == ScenarioType.scenarioOutline
                ? Target.scenarioOutline
                : Target.scenario,
            name: scenario.name,
            description: scenario.description,
            context: scenario.debug,
            tags: scenario.tags.isEmpty
                ? []
                : scenario.tags
                    .map(
                      (t) => t.tags
                          .map(
                            (tag) => Tag(
                              tag,
                              t.debug.lineNumber,
                              isInherited: t.isInherited,
                            ),
                          )
                          .toList(),
                    )
                    .reduce((a, b) => a..addAll(b))
                    .toList(growable: false),
          ),
        );

        for (final step in scenario.steps) {
          try {
            final result = await _runStep(
              step,
              config,
              reporter,
              hook,
              world,
              attachmentManager,
              steps,
              !scenarioPassed,
            );
            scenarioPassed = result.result == StepExecutionResult.passed;
          } catch (e) {
            await _log(
              reporter,
              "Step '${step.name}' did not pass, all remaining steps will be skipped",
              step.debug,
              MessageLevel.warning,
            );
            scenarioPassed = false;
          }
        }
      } catch (e, st) {
        await reporter.onException(e, st);
        rethrow;
      } finally {
        await reporter.scenario.onFinished.invoke(
          ScenarioMessage(
            name: scenario.name,
            description: scenario.description,
            context: scenario.debug,
            hasPassed: scenarioPassed,
          ),
        );
        await hook.onAfterScenario(
          config,
          scenario.name,
          tags,
          passed: scenarioPassed,
        );

        try {
          world.dispose();
        } catch (e, st) {
          await reporter.onException(e, st);
          rethrow;
        }
      }
      return callback(widgetTester);
    },
    skip: skip,
    variant: variant,
    tags: scenario.tags,
  );
}

Future<StepResult> _runStep(
  StepRunnable step,
  TestConfiguration config,
  FullReporter reporter,
  Hook hook,
  World world,
  AttachmentManager attachmentManager,
  Iterable<ExecutableStep> steps,
  bool skipExecution,
) async {
  StepResult result;

  await _log(
    reporter,
    "Attempting to run step '${step.name}'",
    step.debug,
    MessageLevel.info,
  );
  await hook.onBeforeStep(world, step.name);
  await reporter.step.onStarted.invoke(
    StepMessage(
      name: step.name,
      context: step.debug,
      table: step.table,
      multilineString:
          step.multilineStrings.isNotEmpty ? step.multilineStrings.first : null,
    ),
  );

  if (skipExecution) {
    result = StepResult(0, StepExecutionResult.skipped);
  } else {
    final code = _matchStepToExecutableStep(
      step,
      steps,
      reporter,
    );
    final parameters = _getStepParameters(step, code);
    result = await code.step.run(
      world,
      reporter,
      config.defaultTimeout,
      parameters,
    );
  }

  await hook.onAfterStep(world, step.name, result);
  await reporter.step.onFinished.invoke(
    StepMessage(
      name: step.name,
      context: step.debug,
      result: result,
      attachments:
          attachmentManager.getAttachmentsForContext(step.name).toList(),
    ),
  );

  return result;
}

ExecutableStep _matchStepToExecutableStep(
  StepRunnable step,
  Iterable<ExecutableStep> steps,
  FullReporter reporter,
) {
  final executable = steps.firstWhereOrNull(
    (s) => s.expression.isMatch(step.debug.lineText),
  );

  if (executable == null) {
    final message = """
      Step definition not found for text:

        '${step.debug.lineText}'

      File path: ${step.debug.filePath}#${step.debug.lineNumber}
      Line:      ${step.debug.lineText}

      ---------------------------------------------

      You must implement the step like below and add the class to the 'stepDefinitions' property in your configuration:

      /// The 'Given' class prefix can be replaced with 'Then', 'When' 'And' or 'But'
      /// All classes can take up to 5 input parameters. With more, you should probably use a table.
      /// For example: `When4<String, bool, int, num>`
      /// You can also specify the type of world context you want
      /// `When4WithWorld<String, bool, int, num, MyWorld>`
      class Given_${step.debug.lineText.trim().replaceAll(RegExp('[^a-zA-Z0-9]'), '_')} extends Given1<String> {
        @override
        RegExp get pattern => RegExp(r"${step.debug.lineText.trim().split(' ').skip(1).join(' ')}");

        @override
        Future<void> executeStep(String input1) async {
          // If the step is "Given I do a 'windy pop'"
          // in this example, input1 would equal 'windy pop'

          // your code...
        }
      }
      """;
    reporter.message(message, MessageLevel.error);

    throw GherkinStepNotDefinedException(message);
  }

  return executable;
}

Iterable<dynamic> _getStepParameters(StepRunnable step, ExecutableStep code) {
  var parameters = code.expression.getParameters(step.debug.lineText);
  if (step.multilineStrings.isNotEmpty) {
    parameters = parameters.toList()..addAll(step.multilineStrings);
  }

  if (step.table != null) {
    parameters = parameters.toList()..add(step.table);
  }

  return parameters;
}

Future<void> _log(
  FullReporter reporter,
  String message,
  RunnableDebugInformation context,
  MessageLevel level,
) async {
  await reporter.message(
    '$message # ${context.filePath}:${context.lineNumber}',
    level,
  );
}
