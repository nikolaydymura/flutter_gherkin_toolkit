import 'package:gherkin/gherkin.dart';

import '../utils/exports.dart';

class WidgetTesterWorld extends World {
  final WidgetTester tester;

  WidgetTesterWorld(this.tester);

  @override
  void dispose() {}
}
