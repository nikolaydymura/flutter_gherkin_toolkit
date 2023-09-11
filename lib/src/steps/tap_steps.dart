import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../worlds/widget_tester_world.dart';

class TapOnWidgetStep
    extends Then3WithWorld<String?, String, String?, WidgetTesterWorld> {
  final String separator;

  TapOnWidgetStep({this.separator = '->'});

  @override
  Future<void> executeStep(String? input1, String input2, String? input3) {
    throw UnimplementedError();
  }

  @override
  Pattern get pattern => RegExp(r'tap on widget (?:([A-Z][A-Za-z0-9$]+)'
      '$separator'
      r')?([A-Z][A-Za-z0-9$]+)(?:'
      '$separator'
      r'(first|last|\d+))?');
}

class TapOnImageStep
    extends Then3WithWorld<String?, String, String?, WidgetTesterWorld> {
  final String separator;

  TapOnImageStep({this.separator = '->'});

  @override
  Future<void> executeStep(String? input1, String input2, String? input3) {
    throw UnimplementedError();
  }

  @override
  Pattern get pattern => RegExp(r'tap on image (?:([A-Z][A-Za-z0-9$]+)'
      '$separator'
      r')?`(.*\.(?:png|jpg|svg|jpeg))`(?:'
      '$separator'
      r'(first|last|\d+))?');
}
