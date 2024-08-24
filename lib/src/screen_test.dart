import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'device_configuration.dart';

@isTest
void screenTest(
  String description,
  FutureOr<void> Function(WidgetTester) scenario, {
  required Widget Function(DeviceConfiguration) bootBuilder,
  required ValueVariant<DeviceConfiguration> variant,
  FutureOr<void> Function()? setUp,
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  dynamic tags,
  int? retry,
}) =>
    testWidgets(description,
        variant: variant,
        skip: skip,
        timeout: timeout,
        semanticsEnabled: semanticsEnabled,
        tags: tags,
        retry: retry, (WidgetTester widgetTester) async {
      final size = variant.currentValue!.surfaceSize + const Offset(0, 60);
      await widgetTester.binding.setSurfaceSize(size);
      widgetTester.view.physicalSize = size;
      widgetTester.view.devicePixelRatio = 1.0;
      widgetTester.binding.platformDispatcher.textScaleFactorTestValue =
          variant.currentValue!.textScaleSize;
      debugDefaultTargetPlatformOverride = variant.currentValue?.platform;
      await widgetTester.pumpWidget(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 60,
              width: size.width,
              child: Column(
                children: [
                  Container(
                    width: size.width,
                    color: Colors.cyanAccent,
                    child: Text(
                      variant.currentValue?.displayName ?? '',
                      textDirection: TextDirection.ltr,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  const Expanded(
                    child: ColoredBox(
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: Colors.white70,
                child: bootBuilder.call(variant.currentValue!),
              ),
            ),
          ],
        ),
      );
      await setUp?.call();
      await widgetTester
          .runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
      await widgetTester.pumpAndSettle();
      final finder = find.text('!!!SHOW!!!');
      expect(finder, findsOneWidget);
      await widgetTester.tap(finder);
      await widgetTester
          .runAsync(() => Future.delayed(const Duration(milliseconds: 100)));
      await widgetTester.pump();
      await widgetTester.pumpAndSettle();
      await scenario.call(widgetTester);
      await widgetTester
          .runAsync(() => Future.delayed(const Duration(milliseconds: 200)));
      await widgetTester.pumpAndSettle(const Duration(milliseconds: 200));
      debugDefaultTargetPlatformOverride = null;
    });
