import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

extension AdvancedWidgetTester on WidgetTester {
  Future<void> scrollListView(double delta,
      {Axis axis = Axis.vertical, Duration wait = const Duration(milliseconds: 100)}) async {
    final scrollingListView = find.byType(ListView).evaluate();
    if (scrollingListView.isNotEmpty) {
      await fling(find.byType(ListView).first,
          Offset(0, delta), 1000);
    } else {
      await fling(find
          .byType(ListView)
          .first,
          Offset(0, delta), 1000);
    }
    await pumpAndSettle(wait);
    await runAsync(() => Future.delayed(wait));
  }
}