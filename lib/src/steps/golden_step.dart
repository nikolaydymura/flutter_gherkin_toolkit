import 'dart:async';

import 'package:gherkin/gherkin.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../flutter_gherkin_toolkit.dart';

class GoldenStep extends Then1WithWorld<String, WidgetTesterWorld> {
  @override
  Future<void> executeStep(String input1) async {
    final actualFinder = find.byWidgetPredicate((w) => true).first;
    await expectLater(
      actualFinder,
      matchesGoldenFile(input1),
    );
  }

  @override
  Pattern get pattern => 'Given golden file at {string}';
}
