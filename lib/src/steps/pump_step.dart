import 'package:gherkin/gherkin.dart';

import '../worlds/widget_tester_world.dart';

StepDefinitionGeneric andPump() {
  return and<WidgetTesterWorld>(
    RegExp(r'pump\s*'),
    (context) async {
      await context.world.tester.pump();
    },
  );
}

StepDefinitionGeneric andPumpAndSettle() {
  return and<WidgetTesterWorld>(
    RegExp(r'pumpAndSettle\s*'),
    (context) async {
      await context.world.tester.pumpAndSettle();
    },
  );
}

StepDefinitionGeneric andPumpWithDuration({Duration wait = Duration.zero}) {
  return and2<String, String, WidgetTesterWorld>(
    RegExp(r'pump\s*(\d+)\s+(second|seconds|milliseconds)'),
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

StepDefinitionGeneric andPumpAndSettleWithDuration(
    {Duration wait = Duration.zero}) {
  return and2<String, String, WidgetTesterWorld>(
    RegExp(r'pumpAndSettle\s*(\d+)\s+(second|seconds|milliseconds)'),
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
