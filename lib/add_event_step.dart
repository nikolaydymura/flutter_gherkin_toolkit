import 'package:flutter_gherkin_toolkit/flutter_gherkin_toolkit.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric whenAddByNameEvent() {
  return when1<String, CounterBlocWorld>(
    'add {string} event',
    (input1, context) async {
      if (input1 == 'Increment') {
        context.world.counterBloc.add(const Increment());
      } else if (input1 == 'Decrement') {
        context.world.counterBloc.add(const Decrement());
      }
    },
  );
}

StepDefinitionGeneric whenAddByNameWithNumberValueEvent() {
  return when1<String, CounterBlocWorld>(
    'add {string} event',
        (input1, context) async {
      if (input1 == 'Increment') {
        context.world.counterBloc.add(const Increment());
      } else if (input1 == 'Decrement') {
        context.world.counterBloc.add(const Decrement());
      }
    },
  );
}