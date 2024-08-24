import 'dart:io';
import 'package:collection/collection.dart';

import 'package:path/path.dart';

void main() async {
  final screenshotsRoot =
      Directory(join(Directory.current.path, 'test', 'screenshots'));
  final screenshots =
  screenshotsRoot
      .listSync(recursive: true)
      .whereType<File>()
      .where((e) => e.path.endsWith('.png'))
      .toList();

  final alternatives =
      screenshots.groupListsBy((f) => basename(f.path).split('+').first);
  final previewsRoot =
      Directory(join(Directory.current.path, 'test', 'previews'));
  await previewsRoot.create(recursive: true);
  for (final preview in alternatives.keys) {
    final files = alternatives[preview]!;
    await Process.run(
      'magick',
      [
        'convert',
        '+smush',
        '17',
        '-gravity',
        'center',
        '-background',
        'gray',
        ...files.map((e) => e.path),
        '${previewsRoot.path}/$preview.png',
      ],
      runInShell: true,
    );
  }
}
