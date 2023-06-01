import 'dart:math';

import 'package:flutter_gherkin_toolkit/add_event_step.dart';
import 'package:flutter_gherkin_toolkit/expect_state_step.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_gherkin_toolkit/flutter_gherkin_toolkit.dart';
import 'package:gherkin/gherkin.dart';

Future<void> main() {
  final steps = [
    whenAddByNameEvent(),
    thenStateIs()
  ];
  final config = TestConfiguration.standard(
    steps,
    featurePath: 'test/features/increment_bloc.feature',
    createWorld: (config) => Future.value(CounterBlocWorld()),
  );

  return GherkinRunner().execute(config);
}
