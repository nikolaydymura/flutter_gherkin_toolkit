// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:example/pages/home_page.dart';
import 'package:example/pages/second_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gherkin_toolkit/flutter_gherkin_toolkit.dart';

void main() async {
  final steps = [
    LoadWidgetStep({
      'home': () =>
          const MaterialApp(home: HomePage(title: 'Flutter Demo Home Page')),
      'second': () => const MaterialApp(home: SecondPage(title: 'Second Page')),
    }),
  ];
  final config = WidgetTestConfiguration.standard(
    steps,
    featurePath: 'test/features/tap.feature',
  );

  await WidgetRunner().execute(config);
}
