import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';

Future<void> flutterTestConfig({
  Map<String, Set<String>> fonts = const {},
  double goldenThreshold = 0.0,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final entry in fonts.entries) {
    await loadFonts(entry.key, entry.value.toList());
  }
  final result = await Process.run('which', ['flutter']);
  final flutterBin = File(result.stdout.toString().trim());
  final materialFonts =
      Directory('${flutterBin.parent.path}/cache/artifacts/material_fonts')
          .listSync()
          .whereType<File>()
          .where((e) => e.path.endsWith('.ttf'));
  await loadFonts(
    'Roboto',
    materialFonts
        .where((e) => basename(e.path).startsWith('Roboto-'))
        .map((e) => e.path)
        .toList(),
  );

  final materialIconsFontLoader = FontLoader('MaterialIcons')
    ..addFont(
      File(
        '${flutterBin.parent.path}/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      )
          .readAsBytes()
          .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer)),
    );
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
