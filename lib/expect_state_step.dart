import 'package:flutter_gherkin_toolkit/flutter_gherkin_toolkit.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric thenStateIs() {
  return then1<num, CounterBlocWorld>(
    'the state is {num}',
    (input1, context) async {
      context.expectMatch(context.world.counterBloc.state, input1);
    },
  );
}
