import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

import '../utils/string.dart';
import '../worlds/widget_tester_world.dart';

class TapOnTextStep
    extends Then3WithWorld<String?, String, String?, WidgetTesterWorld> {
  final String separator;
  final Type Function(String)? converter;

  TapOnTextStep({this.separator = '->', this.converter});

  @override
  Future<void> executeStep(
      String? input1, String input2, String? input3) async {
    Finder finder = find.text(input2);
    if (input1 != null) {
      final type = input1.widgetType ?? converter?.call(input1);
      if (type == null) {
        throw Exception('Widget type $input1 not found');
      }
      finder = find.ancestor(
          of: finder, matching: find.byType(type), matchRoot: true);
    }

    if (input3 == 'first') {
      finder = finder.first;
    } else if (input3 == 'last') {
      finder = finder.last;
    } else if (input3 != null) {
      finder = finder.at(int.parse(input3));
    }
    await world.tester.tap(finder);
  }

  @override
  Pattern get pattern => RegExp(r'tap on text (?:([A-Z][A-Za-z0-9$]+)'
  '$separator'
  r')?`(.*)`(?:'
  '$separator'
  r'(first|last|\d+))?');
}

class TapOnWidgetStep extends Then3WithWorld<String?, String, String?, WidgetTesterWorld> {
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

class TapOnIconsStep extends Then3WithWorld<String?, String, String?, WidgetTesterWorld> {
  final String separator;

  TapOnIconsStep({this.separator = '->'});

  @override
  Future<void> executeStep(String? input1, String input2, String? input3) {
    throw UnimplementedError();
  }

  @override
  Pattern get pattern => RegExp(r'tap on icon (?:([A-Z][A-Za-z0-9$]+)'
  '$separator'
  r')?`((?:Icons|FontAwesomeIcons)\..*)`(?:'
  '$separator'
  r'(first|last|\d+))?');
}

class TapOnImageStep extends Then3WithWorld<String?, String, String?, WidgetTesterWorld> {
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
