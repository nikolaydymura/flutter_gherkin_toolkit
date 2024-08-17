import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> flutterTestConfig({
  Map<String, Set<String>> fonts = const {},
  double goldenThreshold = 0.0,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final entry in fonts.entries) {
    await loadFonts(entry.key, entry.value.toList());
  }
  await loadFonts(
    'Lato',
    {
      'packages/flutter_amazing_test/assets/Lato-Regular.ttf',
    }.toList(),
  );
/*
  final cupertinoIconsFontLoader = FontLoader('packages/cupertino_icons/CupertinoIcons')
    ..addFont(File('/Users/nd/Development/flutter/bin/assets/fonts/CupertinoIcons.ttf')
        .readAsBytes()
        .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer)));
  await cupertinoIconsFontLoader.load();
*/

  final materialIconsFontLoader = FontLoader('MaterialIcons')
    ..addFont(File('/Users/nd/Development/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf')
        .readAsBytes()
        .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer)));
  await materialIconsFontLoader.load();

  if (goldenFileComparator is LocalFileComparator) {
    final testUrl = (goldenFileComparator as LocalFileComparator).basedir;

    goldenFileComparator = _FileComparatorWithThreshold(
      Uri.parse('$testUrl/test.dart'),
      goldenThreshold,
    );
  }
}

Future<void> loadFonts(String family, List<String> paths) {
  final fontLoader = FontLoader(family);
  for (final path in paths) {
    fontLoader.addFont(rootBundle.load(path));
  }
  return fontLoader.load();
}

class _FileComparatorWithThreshold extends LocalFileComparator {
  _FileComparatorWithThreshold(super.testFile, this.threshold)
      : assert(threshold >= 0 && threshold <= 1);
  final double threshold;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed && result.diffPercent <= threshold) {
      return true;
    }

    if (!result.passed) {
      final error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    return result.passed;
  }
}
