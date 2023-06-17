// tap on text `Increment` #1
// tap on text `Increment`->first #2
// tap on text `Increment`->last
// tap on text `Increment`->2


// tap on text TextButton->`Increment` #2
// tap on text FloatingActionButton->`Increment`

// tap on text FloatingActionButton->`Increment`->first #3


// tap on type FloatingActionButton
// tap on icon `Icons.add`
// tap on image `assets/images/arrow_back.png`

import 'package:gherkin/gherkin.dart';

import '../worlds/widget_tester_world.dart';

class TapOnTextStep extends Then1WithWorld<String, WidgetTesterWorld> {
  @override
  Future<void> executeStep(String input1) {
    throw UnimplementedError();
  }

  @override
  Pattern get pattern => RegExp(r'tap on text `(.*)+`');
}
