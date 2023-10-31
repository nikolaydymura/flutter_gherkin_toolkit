import 'dart:async';

import 'package:flutter_gherkin_toolkit/flutter_gherkin_toolkit.dart';

const _kGoldenTestsThreshold = 0.0002;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  registerRemoteFileComparator(
      host: Uri(host: '192.168.3.22'), threshold: _kGoldenTestsThreshold);
  await testMain();
}
