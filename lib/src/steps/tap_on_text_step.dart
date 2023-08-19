import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../../flutter_gherkin_toolkit.dart';

class _TapOnTextStep1 extends Then1WithWorld<String, WidgetTesterWorld> {
  @override
  Future<void> executeStep(String input1) async {
    Finder finder = find.text(input1);
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => 'tap on text {string}';
}

class _TapOnTextStep2 extends Then2WithWorld<String, int, WidgetTesterWorld> {
  final String separator;

  _TapOnTextStep2(this.separator);

  @override
  Future<void> executeStep(String input1, int input2) async {
    Finder finder = find.text(input1).at(input2);
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => 'tap on text {string}$separator{int}';
}

class _TapOnTextStep3
    extends Then2WithWorld<String, String, WidgetTesterWorld> {
  final String separator;

  _TapOnTextStep3(this.separator);

  @override
  Future<void> executeStep(String input1, String input2) async {
    Finder finder = find.text(input1);
    if (input2 == 'first') {
      finder = finder.first;
    } else if (input2 == 'last') {
      finder = finder.last;
    }
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => 'tap on text {string}$separator{anchor}';
}

class _TapOnTextStep4 extends Then2WithWorld<Type, String, WidgetTesterWorld> {
  final String separator;

  _TapOnTextStep4(this.separator);

  @override
  Future<void> executeStep(Type input1, String input2) async {
    final finder = find.ancestor(
        of: find.text(input2), matching: find.byType(input1), matchRoot: true);
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => 'tap on text {widget}$separator{string}';
}

class _TapOnTextStep5
    extends Then3WithWorld<Type, String, String, WidgetTesterWorld> {
  final String separator;

  _TapOnTextStep5(this.separator);

  @override
  Future<void> executeStep(Type input1, String input2, String input3) async {
    Finder finder = find.ancestor(
        of: find.text(input2), matching: find.byType(input1), matchRoot: true);
    if (input2 == 'first') {
      finder = finder.first;
    } else if (input2 == 'last') {
      finder = finder.last;
    }
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern =>
      'tap on text {widget}$separator{string}$separator{anchor}';
}

class _TapOnTextStep6
    extends Then3WithWorld<Type, String, int, WidgetTesterWorld> {
  final String separator;

  _TapOnTextStep6(this.separator);

  @override
  Future<void> executeStep(Type input1, String input2, int input3) async {
    final finder = find
        .ancestor(
            of: find.text(input2),
            matching: find.byType(input1),
            matchRoot: true)
        .at(input3);
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern =>
      'tap on text {widget}$separator{string}$separator{int}';
}

class TapOnTextStepFactory {
  final String separator;

  TapOnTextStepFactory({this.separator = '->'});

  Iterable<StepDefinitionGeneric> get stepDefinitions => [
        _TapOnTextStep1(),
        _TapOnTextStep2(separator),
        _TapOnTextStep3(separator),
        _TapOnTextStep4(separator),
        _TapOnTextStep5(separator),
        _TapOnTextStep6(separator)
      ].reversed;
}
