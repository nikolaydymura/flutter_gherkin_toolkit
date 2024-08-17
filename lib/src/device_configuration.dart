import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DeviceConfiguration extends Equatable {
  factory DeviceConfiguration.fromJson(Map<String, dynamic> json) {
    return DeviceConfiguration(
      name: json['name'],
      platform: TargetPlatform.values.firstWhere(
        (element) => element.name == json['platform'],
      ),
      surfaceSize: Size(
        json['surfaceSize']['width'],
        json['surfaceSize']['height'],
      ),
      localeOverrides: Locale(json['localeOverrides']),
      textScaleSize: json['textScaleSize'],
    );
  }

  const DeviceConfiguration({
    this.name = 'iPhone 15 Pro Max',
    this.platform = TargetPlatform.iOS,
    this.surfaceSize = const Size(430, 932),
    this.textScaleSize = 1.0,
    this.localeOverrides = const Locale('en'),
  });

  final String name;
  final TargetPlatform platform;
  final Size surfaceSize;
  final Locale localeOverrides;
  final double textScaleSize;

  @override
  List<Object?> get props =>
      [name, platform, surfaceSize, localeOverrides, textScaleSize];

  @override
  String toString() {
    return '${name}_${platform.name}_${surfaceSize.width.toInt()}x${surfaceSize.height.toInt()}_${localeOverrides.languageCode}_$textScaleSize'
        .replaceAll(' ', '_');
  }

  String get displayName {
    return '$name (${platform.name}) ${surfaceSize.width.toInt()}x${surfaceSize.height.toInt()} ${localeOverrides.languageCode} $textScaleSize';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'platform': platform.name,
      'surfaceSize': {
        'width': surfaceSize.width,
        'height': surfaceSize.height,
      },
      'localeOverrides': localeOverrides.languageCode,
      'textScaleSize': textScaleSize,
    };
  }
}
