import 'package:get_it/get_it.dart';
import 'package:gherkin/gherkin.dart';

import '../../flutter_gherkin_toolkit.dart';
import '../mocks/cache_manager_mocks.dart';
import '../utils/exports.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class GoldenStep extends Then1WithWorld<String, WidgetTesterWorld> {
  @override
  Future<void> executeStep(String input1) async {
    GetIt.instance.registerSingleton<BaseCacheManager>(
      TestCacheManager(),
    );
    final actualFinder = find.byWidgetPredicate((w) => true).first;
    await loadAppFonts();
    await world.tester.pump();
    await expectLater(
      actualFinder,
      matchesGoldenFile(input1),
    );
  }

  @override
  Pattern get pattern => 'Given golden file at {string}';
}
