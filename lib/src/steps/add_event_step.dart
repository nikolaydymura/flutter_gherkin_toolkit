import 'dart:convert';
import 'dart:io';

import 'package:flutter_gherkin_toolkit/flutter_gherkin_toolkit.dart';
import 'package:flutter_gherkin_toolkit/src/utils/string.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric whenAddEvent({String paramsSeparator = ','}) {
  return when3<String, String, String, MultiBlocWorld>(
    RegExp(
        r'''["`']?([A-Z][_$A-Za-z0-9]+(?:Bloc|Cubit))["`']? add ["`']?([A-Z][_$A-Za-z0-9]+(?:Event|Action)?)["`']?\s*(?:with|from)?\s*(.*)\s*'''),
    (blocName, eventName, content, context) async {
      final payload = content.trim();
      if (payload.endsWith('.json')) {
        final result = File(payload).readAsStringSync();
        final body = jsonDecode(result);
        context.world.addEventPayload(blocName, eventName, body);
      } else if (payload.isJson) {
        final body = jsonDecode(payload);
        context.world.addEventPayload(blocName, eventName, body);
      } else if (payload.isNotEmpty) {
        final args =
            payload.split(paramsSeparator).map((e) => e.value).toList();
        context.world.addEvent(blocName, eventName, args);
      } else {
        context.world.addEvent(blocName, eventName);
      }
    },
  );
}
