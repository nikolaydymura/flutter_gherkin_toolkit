import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class RemoteFileComparator extends GoldenFileComparator
    with LocalComparisonOutput {
  /// Creates a new [RemoteFileComparator] for the specified [testFile].
  ///
  /// Golden file keys will be interpreted as file paths relative to the
  /// directory in which [testFile] resides.
  ///
  /// The [testFile] URL must represent a file.
  RemoteFileComparator(Uri testFile, this._host, this._root,
      {path.Style? pathStyle, this.threshold})
      : basedir = _getBasedir(testFile, pathStyle),
        _path = _getPath(pathStyle);

  static path.Context _getPath(path.Style? style) {
    return path.Context(style: style ?? path.Style.platform);
  }

  static Uri _getBasedir(Uri testFile, path.Style? pathStyle) {
    final path.Context context = _getPath(pathStyle);
    final String testFilePath = context.fromUri(testFile);
    final String testDirectoryPath = context.dirname(testFilePath);
    return context.toUri(testDirectoryPath + context.separator);
  }

  /// The directory in which the test was loaded.
  ///
  /// Golden file keys will be interpreted as file paths relative to this
  /// directory.
  final Uri basedir;

  /// Path context exists as an instance variable rather than just using the
  /// system path context in order to support testing, where we can spoof the
  /// platform to test behaviors with arbitrary path styles.
  final path.Context _path;

  final Uri _host;
  final double? threshold;
  final String _root;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final ComparisonResult result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    final threshold = this.threshold;
    if (!result.passed &&
        threshold != null &&
        result.diffPercent <= threshold) {
      debugPrint(
        'A difference of ${result.diffPercent * 100}% was found, but it is '
        'acceptable since it is not greater than the threshold of '
        '${threshold * 100}%',
      );

      return true;
    }

    if (!result.passed) {
      final String error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    return result.passed;
  }

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) async {
    await http.post(_host.replace(path: 'sync'),
        headers: {'Golden-Destination': _getGoldenPath(golden)},
        body: imageBytes);
  }

  /// Returns the bytes of the given [golden] file.
  ///
  /// If the file cannot be found, an error will be thrown.
  @protected
  Future<List<int>> getGoldenBytes(Uri golden) async {
    final response = await http.get(_host.replace(path: 'sync'),
        headers: {'Golden-Destination': _getGoldenPath(golden)});
    if (response.statusCode != 200) {
      fail('Could not be compared against non-existent file: "$golden"');
    }
    final List<int> goldenBytes = response.bodyBytes;
    return goldenBytes;
  }

  String _getGoldenPath(Uri golden) => _path.join(
      _path.fromUri(basedir),
      path.join(path.join(_root, Platform.operatingSystem),
          _path.fromUri(golden.path)));

  @override
  Future<String> generateFailureOutput(
    ComparisonResult result,
    Uri golden,
    Uri basedir, {
    String key = '',
  }) async =>
      TestAsyncUtils.guard<String>(() async {
        String additionalFeedback = '';
        if (result.diffs != null) {
          additionalFeedback =
              '\nFailure feedback can be found at ${path.join(basedir.path, 'failures')}';
          final Map<String, Image> diffs = result.diffs!;
          for (final MapEntry<String, Image> entry in diffs.entries) {
            final output = getFailurePath(
              key.isEmpty ? entry.key : '${entry.key}_$key',
              golden,
              basedir,
            );
            final ByteData? pngBytes =
                await entry.value.toByteData(format: ImageByteFormat.png);
            await http.post(_host.replace(path: 'sync'),
                headers: {'Golden-Destination': output},
                body: pngBytes!.buffer.asUint8List());
          }
        }
        return 'Golden "$golden": ${result.error}$additionalFeedback';
      });

  String getFailurePath(String failure, Uri golden, Uri basedir) {
    final String fileName = golden.pathSegments.last;
    final String testName =
        '${fileName.split(path.extension(fileName))[0]}_$failure.png';
    return path.join(
      path.fromUri(basedir),
      path.fromUri(Uri.parse('failures/$testName')),
    );
  }
}

void registerRemoteFileComparator({required Uri host, double? threshold}) {
  if (goldenFileComparator is LocalFileComparator) {
    final testUrl = (goldenFileComparator as LocalFileComparator).basedir;

    goldenFileComparator = RemoteFileComparator(
      Uri.parse('$testUrl/test.dart'),
      host,
      'goldens',
      threshold: threshold,
    );
  } else {
    throw Exception(
      'Expected `goldenFileComparator` to be of type `LocalFileComparator`, '
      'but it is of type `${goldenFileComparator.runtimeType}`',
    );
  }
}
