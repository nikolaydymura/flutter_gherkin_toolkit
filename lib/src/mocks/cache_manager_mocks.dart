import 'dart:typed_data';

import 'package:file/src/interface/file.dart' as fi;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:image/image.dart' as img;

export 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TestCacheManager extends BaseCacheManager {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  Stream<FileResponse> getFileStream(
      String url, {
        String? key,
        Map<String, String>? headers,
        bool? withProgress,
      }) async* {
    if (url.contains('photo-1682687221006-b7fd60cf9dd0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80')) {
      yield FileInfo(
        FakeImageFile(800, 600, Colors.deepOrangeAccent),
        FileSource.Cache,
        DateTime.now().add(const Duration(days: 1)),
        url,
      );
    }else {
      throw 'No image placeholder defined for $url';
    }
  }
}

class FakeImageFile extends Fake implements fi.File {
  final int width;
  final int height;
  final Color color;

  FakeImageFile(this.width, this.height, this.color);

  @override
  Future<Uint8List> readAsBytes() async {
    final image = img.Image(width, height);
    image.fill(
      img.Color.fromRgba(color.red, color.green, color.blue, color.alpha),
    );
    final data = img.encodeJpg(image);
    return Uint8List.fromList(data);
  }
}