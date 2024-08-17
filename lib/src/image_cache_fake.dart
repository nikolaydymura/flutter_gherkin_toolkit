import 'dart:typed_data';
import 'package:file/file.dart' as file;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

class CacheManagerFake extends Fake implements DefaultCacheManager {
  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool? withProgress,
  }) async* {
    yield FileInfo(
      FakeImageFile(479, 512, Color(url.hashCode)),
      FileSource.Cache,
      DateTime.now().add(const Duration(days: 1)),
      url,
    );
  }
}

class FakeImageFile extends Fake implements file.File {
  FakeImageFile(this.width, this.height, this.color);

  final int width;
  final int height;
  final Color color;

  @override
  Future<Uint8List> readAsBytes() async {
    final image = img.Image(width: width, height: height);
    img.fill(
      image,
      color: img.ColorRgba8(color.red, color.green, color.blue, color.alpha),
    );
    final data = img.encodeJpg(image);
    return Uint8List.fromList(data);
  }
}
