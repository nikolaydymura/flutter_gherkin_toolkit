import 'package:flutter_gherkin_toolkit/flutter_gherkin_toolkit.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric andPump({Duration wait = Duration.zero}) {
  return and2<String, String, WidgetTesterWorld>(
    RegExp(r'pump\s*(?:(\d+) (milliseconds))?'),
    (durationValue, timeUnit, context) async {
      final duration = int.tryParse(durationValue.trim());
      if (duration != null) {
        if (timeUnit.trim().startsWith('second')) {
          await context.world.tester.pump(Duration(seconds: duration));
        } else {
          await context.world.tester.pump(Duration(milliseconds: duration));
        }
      }
    },
  );
}

StepDefinitionGeneric andPumpAndSettle({Duration wait = Duration.zero}) {
  return and2<String, String, WidgetTesterWorld>(
    RegExp(r'pump\s*(?:(\d+) (milliseconds))?'),
    (durationValue, timeUnit, context) async {
      final duration = int.tryParse(durationValue.trim());
      if (duration != null) {
        if (timeUnit.trim().startsWith('second')) {
          await context.world.tester.pumpAndSettle(Duration(seconds: duration));
        } else {
          await context.world.tester
              .pumpAndSettle(Duration(milliseconds: duration));
        }
      }
    },
  );
}
