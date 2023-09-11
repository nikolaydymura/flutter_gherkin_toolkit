import 'package:gherkin/gherkin.dart';

import '../../flutter_gherkin_toolkit.dart';
import '../advanced_widget_tester.dart';

class ScrollStep extends Then1WithWorld<double, WidgetTesterWorld> {
  @override
  Future<void> executeStep(double input1) async {
    return world.tester.scrollListView(input1);
  }

  @override
  Pattern get pattern => 'Then scroll {num}';
}
