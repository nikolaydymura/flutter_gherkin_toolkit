import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

extension AdvancedWidgetTester on WidgetTester {
  Future<void> scrollListView(double delta,
      {Axis axis = Axis.vertical,
      Duration wait = const Duration(milliseconds: 100)}) async {
    final customScrolls = find.byType(CustomScrollView).evaluate();
    if (customScrolls.isNotEmpty) {
      await fling(
          find.byType(CustomScrollView).first,
          Offset(axis == Axis.horizontal ? delta : 0,
              axis == Axis.vertical ? delta : 0),
          1000);
    } else {
      await fling(
          find.byType(ListView).first,
          Offset(axis == Axis.horizontal ? delta : 0,
              axis == Axis.vertical ? delta : 0),
          1000);
    }
    await pumpAndSettle(wait);
    await runAsync(() => Future.delayed(wait));
  }
}
