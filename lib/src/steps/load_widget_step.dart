import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../../flutter_gherkin_toolkit.dart';

class LoadWidgetStep extends Given1WithWorld<String, WidgetTesterWorld> {
  final Map<String, Widget Function()> widgets;

  LoadWidgetStep(this.widgets);

  @override
  Future<void> executeStep(String input1) async {
    final widgetBuilder = widgets[input1];
    if (widgetBuilder == null) {
      fail('No widget builder found for $input1');
    }
    await world.tester.pumpWidget(widgetBuilder.call());
  }

  @override
  Pattern get pattern => 'the widget builder by {string}';
}
