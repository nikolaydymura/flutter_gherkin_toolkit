import 'package:flutter_gherkin_toolkit/flutter_gherkin_toolkit.dart';
import 'package:gherkin/gherkin.dart';

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
    RegExp(r'pump\s*(?:(\d+) (millisecond(s)?))?'),
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

StepDefinitionGeneric andPumpAndSettleWithDuration({Duration wait = Duration.zero}) {
  return and2<String, String, WidgetTesterWorld>(
    RegExp(r'pumpAndSettle\s*(?:(\d+) (millisecond(s)?))?'),
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
