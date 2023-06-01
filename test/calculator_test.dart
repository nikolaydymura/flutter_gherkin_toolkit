import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_gherkin_toolkit/flutter_gherkin_toolkit.dart';
import 'package:gherkin/gherkin.dart';

class CalculatorWorld extends World {
  final calculator = Calculator();
}

StepDefinitionGeneric givenTheNumbers() {
  return given2<num, num, CalculatorWorld>(
    'the numbers {num} and {num}',
    (input1, input2, context) async {
      context.world.calculator.storeNumericInput(input1);
      context.world.calculator.storeNumericInput(input2);
    },
  );
}

StepDefinitionGeneric whenTheStoredNumbersAreAdded() {
  return given<CalculatorWorld>(
    'they are added',
    (context) async {
      context.world.calculator.add();
    },
  );
}

StepDefinitionGeneric thenExpectNumericResult() {
  return given1<num, CalculatorWorld>(
    'the expected result is {num}',
    (input1, context) async {
      final result = context.world.calculator.getNumericResult();
      context.expectMatch(result, input1);
    },
  );
}

class PowerOfTwoParameter extends CustomParameter<int> {
  PowerOfTwoParameter()
      : super(
          'POW',
          RegExp(r'([0-9]+\^[0-9]+)'),
          (input) {
            final parts = input.split('^');
            return pow(int.parse(parts[0]), int.parse(parts[1])) as int;
          },
        );
}

class HookExample extends Hook {
  /// The priority to assign to this hook.
  /// Higher priority gets run first so a priority of 10 is run before a priority of 2
  @override
  int get priority => 1;

  /// Run before any scenario in a test run have executed
  @override
  Future<void> onBeforeRun(TestConfiguration config) async {
    print('before run hook');
  }

  /// Run after all scenarios in a test run have completed
  @override
  Future<void> onAfterRun(TestConfiguration config) async {
    print('after run hook');
  }

  /// Run before a scenario and it steps are executed
  @override
  Future<void> onBeforeScenario(
    TestConfiguration config,
    String scenario,
    Iterable<Tag> tags,
  ) async {
    print("running hook before scenario '$scenario'");
  }

  /// Run after a scenario has executed
  @override
  Future<void> onAfterScenario(
    TestConfiguration config,
    String scenario,
    Iterable<Tag> tags, {
    bool passed = true,
  }) async {
    print("running hook after scenario '$scenario'");
  }

  /// Run before a step is executed
  @override
  Future<void> onBeforeStep(World world, String step) async {
    print("running hook before step '$step'");
  }

  /// Run after a step has executed
  @override
  Future<void> onAfterStep(
    World world,
    String step,
    StepResult stepResult,
  ) async {
    print("running hook after step '$step'");

    // example of how to add a simple attachment (text, json, image) to a step that a reporter can use
    world.attach('attachment data', 'text/plain', step);
  }
}

Future<void> main() {
  final steps = [
    givenTheNumbers(),
    whenTheStoredNumbersAreAdded(),
    thenExpectNumericResult()
  ];
  final config = TestConfiguration.standard(
    steps,
    featurePath: 'test/features/calculator.feature',
    hooks: [HookExample()],
    customStepParameterDefinitions: [PowerOfTwoParameter()],
    createWorld: (config) => Future.value(CalculatorWorld()),
  );

  return GherkinRunner().execute(config);
}