import 'dart:convert';
import 'dart:io';

import 'package:flutter_gherkin_toolkit/flutter_gherkin_toolkit.dart';
import 'package:flutter_gherkin_toolkit/src/utils/string.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric andWait({Duration wait = Duration.zero}) {
  return and2<String, String, MultiBlocWorld>(
    RegExp(r'wait\s*(?:(\d+) (milliseconds|seconds|second))?'),
    (durationValue, timeUnit, context) async {
      final duration = int.tryParse(durationValue.trim());
      if (duration == null && wait != Duration.zero) {
        await Future.delayed(wait);
      } else if (duration != null) {
        if (timeUnit.trim().startsWith('second')) {
          await Future.delayed(Duration(seconds: duration));
        } else {
          await Future.delayed(Duration(milliseconds: duration));
        }
      }
    },
  );
}
