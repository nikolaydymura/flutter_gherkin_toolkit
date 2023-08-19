import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../../flutter_gherkin_toolkit.dart';

class _TapOnIconStep1 extends Then1WithWorld<IconData, WidgetTesterWorld> {
  @override
  Future<void> executeStep(IconData input1) async {
    Finder finder = find.byIcon(input1);
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => 'tap on icon {icondata}';
}

class _TapOnIconStep2 extends Then2WithWorld<IconData, int, WidgetTesterWorld> {
  final String separator;

  _TapOnIconStep2(this.separator);

  @override
  Future<void> executeStep(IconData input1, int input2) async {
    Finder finder = find.byIcon(input1).at(input2);
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => 'tap on icon {icondata}$separator{int}';
}

class _TapOnIconStep3
    extends Then2WithWorld<IconData, String, WidgetTesterWorld> {
  final String separator;

  _TapOnIconStep3(this.separator);

  @override
  Future<void> executeStep(IconData input1, String input2) async {
    Finder finder = find.byIcon(input1);
    if (input2 == 'first') {
      finder = finder.first;
    } else if (input2 == 'last') {
      finder = finder.last;
    }
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => 'tap on icon {icondata}$separator{anchor}';
}

class _TapOnIconStep4 extends Then2WithWorld<Type, IconData, WidgetTesterWorld> {
  final String separator;

  _TapOnIconStep4(this.separator);

  @override
  Future<void> executeStep(Type input1, IconData input2) async {
    final finder = find.ancestor(
        of: find.byIcon(input2), matching: find.byType(input1), matchRoot: true);
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => 'tap on icon {widget}$separator{icondata}';
}

class _TapOnIconStep5
    extends Then3WithWorld<Type, String, IconData, WidgetTesterWorld> {
  final String separator;

  _TapOnIconStep5(this.separator);

  @override
  Future<void> executeStep(Type input1, String input2, IconData input3) async {
    Finder finder = find.ancestor(
        of: find.byIcon(input3), matching: find.byType(input1), matchRoot: true);
    if (input2 == 'first') {
      finder = finder.first;
    } else if (input2 == 'last') {
      finder = finder.last;
    }
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern =>
      'tap on icon {widget}$separator{icondata}$separator{anchor}';
}

class _TapOnIconStep6
    extends Then3WithWorld<Type, IconData, int, WidgetTesterWorld> {
  final String separator;

  _TapOnIconStep6(this.separator);

  @override
  Future<void> executeStep(Type input1, IconData input2, int input3) async {
    final finder = find
        .ancestor(
        of: find.byIcon(input2),
        matching: find.byType(input1),
        matchRoot: true)
        .at(input3);
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern =>
      'tap on icon {widget}$separator{icondata}$separator{int}';
}

class TapOnIconStepFactory {
  final String separator;

  TapOnIconStepFactory({this.separator = '->'});

  Iterable<StepDefinitionGeneric> get stepDefinitions => [
    _TapOnIconStep1(),
    _TapOnIconStep2(separator),
    _TapOnIconStep3(separator),
    _TapOnIconStep4(separator),
    _TapOnIconStep5(separator),
    _TapOnIconStep6(separator)
  ].reversed;
}
