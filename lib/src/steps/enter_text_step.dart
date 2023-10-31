import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../worlds/widget_tester_world.dart';

class _EnterTextStep1 extends Then1WithWorld<String, WidgetTesterWorld> {
  @override
  Future<void> executeStep(String input1) async {
    Finder finder = find.byType(TextField);
    await world.tester.enterText(finder, input1);
  }

  @override
  Pattern get pattern => 'enter text {string}';
}

class _EnterTextStep2 extends Then2WithWorld<String, int, WidgetTesterWorld> {
  @override
  Future<void> executeStep(String input1, int input2) async {
    Finder finder = find.byType(TextField).at(input2);
    await world.tester.enterText(finder, input1);
  }

  @override
  Pattern get pattern => 'enter text {string} at {int}';
}

class _EnterTextStep3 extends Then2WithWorld<String, String, WidgetTesterWorld> {
  @override
  Future<void> executeStep(String input1, String input2) async {
    Finder finder = find.byType(TextField);
    if (input2 == 'first') {
      finder = finder.first;
    } else if (input2 == 'last') {
      finder = finder.last;
    }
    await world.tester.enterText(finder, input1);
  }

  @override
  Pattern get pattern => 'enter text {string} on {anchor}';
}

class _EnterTextStep4 extends Then2WithWorld<String, Type, WidgetTesterWorld> {
  @override
  Future<void> executeStep(String input1, Type input2) async {
    final finder = find.descendant(
        of: find.byType(input2),
        matching: find.byType(TextField),
        matchRoot: true);
    await world.tester.enterText(finder, input1);
  }

  @override
  Pattern get pattern => 'enter text {string} in {widget}';
}

class _EnterTextStep5
    extends Then3WithWorld<String, Type, String, WidgetTesterWorld> {
  @override
  Future<void> executeStep(String input1, Type input2, String input3) async {
    Finder finder = find.descendant(
        of: find.byType(input2),
        matching: find.byType(TextField),
        matchRoot: true);
    if (input3 == 'first') {
      finder = finder.first;
    } else if (input3 == 'last') {
      finder = finder.last;
    }
    await world.tester.enterText(finder, input1);
  }

  @override
  Pattern get pattern => 'enter text {string} on {anchor} in {widget}';
}

class _EnterTextStep6
    extends Then3WithWorld<String, Type, int, WidgetTesterWorld> {
  @override
  Future<void> executeStep(String input1, Type input2, int input3) async {
    final finder = find
        .descendant(
            of: find.byType(input2),
            matching: find.byType(TextField),
            matchRoot: true)
        .at(input3);
    await world.tester.enterText(finder, input1);
  }

  @override
  Pattern get pattern => 'enter text {string} at {int} in {widget}';
}

class EnterTextStepFactory {
  Iterable<StepDefinitionGeneric> get stepDefinitions => [
        _EnterTextStep1(),
        _EnterTextStep2(),
        _EnterTextStep3(),
        _EnterTextStep4(),
        _EnterTextStep4(),
        _EnterTextStep5(),
        _EnterTextStep6()
      ].reversed;
}