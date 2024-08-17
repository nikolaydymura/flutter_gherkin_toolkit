import 'package:flutter/material.dart';

Widget materialAppWrapper({
  TargetPlatform platform = TargetPlatform.android,
  Locale? localeOverrides,
  double? textScaleFactor,
  ThemeData? theme,
  Iterable<Locale> supportedLocales = const <Locale>[Locale('en', 'US')],
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  RouterConfig<Object>? routerConfig,
}) {
  return MaterialApp.router(
    routerConfig: routerConfig,
    localizationsDelegates: localizationsDelegates,
    locale: localeOverrides,
    supportedLocales: supportedLocales,
    theme: theme?.copyWith(platform: platform),
    debugShowCheckedModeBanner: false,
  );
}
