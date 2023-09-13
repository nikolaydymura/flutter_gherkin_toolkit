import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../../flutter_gherkin_toolkit.dart';

class _ExpectValue extends Then1WithWorld<String, WidgetTesterWorld> {

  _ExpectValue();

  @override
  Future<void> executeStep(String input1) async {
    expect(find.text(input1), findsOneWidget);
  }

  @override
  Pattern get pattern => 'expect {String}';
}

class ExpectValueFactory {

  ExpectValueFactory();

  Iterable<StepDefinitionGeneric> get stepDefinitions => [
    _ExpectValue(),
  ].reversed;
}
