import 'package:gherkin/gherkin.dart';

import '../flutter_gherkin_toolkit.dart';
import 'steps/expect_value_step.dart';
import 'steps/golden_step.dart';
import 'steps/pump_step.dart';
import 'steps/tap_on_icon_step.dart';

class WidgetTestConfiguration extends TestConfiguration {
  WidgetTestConfiguration.standard(Iterable<StepDefinitionGeneric<World>> steps,
      {required String featurePath})
      : super.standard(
          [
            ...TapOnTextStepFactory().stepDefinitions,
            ...TapOnIconStepFactory().stepDefinitions,
            ...ExpectValueFactory().stepDefinitions,
            GoldenStep(),
            andWidgetWait(),
            andPump(),
            andPumpAndSettle(),
            ...steps
          ],
          featurePath: featurePath,
          customStepParameterDefinitions: [
            WidgetTypeParameter(),
            IconDataParameter(),
            ElementAnchorParameter()
          ],
        );
}
