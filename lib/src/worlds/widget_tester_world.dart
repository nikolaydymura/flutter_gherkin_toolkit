import 'package:gherkin/gherkin.dart';
import 'package:flutter_test/flutter_test.dart';

class WidgetTesterWorld extends World {
  final WidgetTester tester;

  WidgetTesterWorld(this.tester);

  @override
  void dispose() {
  }
}
