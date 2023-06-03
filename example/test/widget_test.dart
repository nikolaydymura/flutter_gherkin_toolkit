// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:example/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gherkin_toolkit/flutter_gherkin_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';
import 'package:gherkin/gherkin.dart';

class CounterEventParameter extends EventParameter<CounterEvent> {
  CounterEventParameter()
      : super(
          [IncrementEvent, DecrementEvent],
            (value, [args]) {
            switch (value) {
              case 'IncrementEvent':
                return const IncrementEvent();
              case 'DecrementEvent':
                return const DecrementEvent();
              default:
                throw Exception('Event not found');
            }
          },
        );
}

Future<void> main() {
  final steps = [whenAddEvent(), thenLatestStateIs(), andWait()];
  final config = TestConfiguration.standard(
    steps,
    featurePath: 'test/features/increment_bloc.feature',
    createWorld: (config) => Future.value(MultiBlocWorld(
      [CounterBlocWorld()],
    )),
  );

  return GherkinRunner().execute(config);
}

class CounterBlocWorld extends BlocWorld<CounterEvent, int> {
  @override
  BlocBase<int> build() => CounterBloc();

  @override
  FutureOr<void> invokeMethod(String name, [dynamic args]) {}

  @override
  CounterEvent mapEvent(String name, [dynamic args]) {
    switch (name) {
      case 'IncrementEvent':
        return const IncrementEvent();
      case 'DecrementEvent':
        return const DecrementEvent();
      default:
        throw Exception('Event not found');
    }
  }
}
