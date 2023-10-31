import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../worlds/widget_tester_world.dart';

class _TapOnTypeStep1 extends Then1WithWorld<Type, WidgetTesterWorld> {
  @override
  Future<void> executeStep(Type input1) async {
    Finder finder = find.byType(input1);
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => 'tap on type {widget}';
}

class _TapOnTypeStep2 extends Then2WithWorld<Type, int, WidgetTesterWorld> {
  final String separator;

  _TapOnTypeStep2(this.separator);

  @override
  Future<void> executeStep(Type input1, int input2) async {
    Finder finder = find.byType(input1);
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => 'tap on type {widget}$separator{int}';
}

class _TapOnTypeStep3
    extends Then2WithWorld<Type, String, WidgetTesterWorld> {
  final String separator;

  _TapOnTypeStep3(this.separator);

  @override
  Future<void> executeStep(Type input1, String input2) async {
    Finder finder = find.byType(input1);
    if (input2 == 'first') {
      finder = finder.first;
    } else if (input2 == 'last') {
      finder = finder.last;
    }
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => 'tap on type {widget}$separator{anchor}';
}

class _TapOnTypeStep4 extends Then2WithWorld<Type, Type, WidgetTesterWorld> {
  final String separator;

  _TapOnTypeStep4(this.separator);

  @override
  Future<void> executeStep(Type input1, Type input2) async {
    final finder = find.ancestor(
        of: find.byType(input2), matching: find.byType(input1), matchRoot: true);
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => 'tap on type {widget}$separator{widget}';
}

class _TapOnTypeStep5
    extends Then3WithWorld<Type, Type, String, WidgetTesterWorld> {
  final String separator;

  _TapOnTypeStep5(this.separator);

  @override
  Future<void> executeStep(Type input1, Type input2, String input3) async {
    Finder finder = find.ancestor(
        of: find.byType(input2), matching: find.byType(input1), matchRoot: true);
    if (input3 == 'first') {
      finder = finder.first;
    } else if (input3 == 'last') {
      finder = finder.last;
    }
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern =>
      'tap on type {widget}$separator{widget}$separator{anchor}';
}

class _TapOnTypeStep6
    extends Then3WithWorld<Type, Type, int, WidgetTesterWorld> {
  final String separator;

  _TapOnTypeStep6(this.separator);

  @override
  Future<void> executeStep(Type input1, Type input2, int input3) async {
    final finder = find
        .ancestor(
        of: find.byType(input2),
        matching: find.byType(input1),
        matchRoot: true)
        .at(input3);
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern =>
      'tap on type {widget}$separator{widget}$separator{int}';
}

class TapOnTypeStepFactory {
  final String separator;

  TapOnTypeStepFactory({this.separator = '->'});

  Iterable<StepDefinitionGeneric> get stepDefinitions => [
    _TapOnTypeStep1(),
    _TapOnTypeStep2(separator),
    _TapOnTypeStep3(separator),
    _TapOnTypeStep4(separator),
    _TapOnTypeStep5(separator),
    _TapOnTypeStep6(separator)
  ].reversed;
}