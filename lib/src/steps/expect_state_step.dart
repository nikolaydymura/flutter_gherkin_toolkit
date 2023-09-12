import '../../flutter_gherkin_toolkit.dart';
import '../utils/string.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric thenLatestStateIs() {
  return then2<String, String, MultiBlocWorld>(
    RegExp(
        r'''["`']?([A-Z][_$A-Za-z0-9]+(?:Bloc|Cubit))["`']? state\s*(?:is|from)?\s*(.*)\s*'''),
    (blocName, expectedValue, context) async {
      final state = expectedValue.trim();
      /*if (state.endsWith('.json')) {
        final result = File(state).readAsStringSync();
        final body = jsonDecode(result);
        context.world.addEventPayload(blocName, eventName, body);
      } else if (state.isJson) {
        final body = jsonDecode(state);
        context.world.addEventPayload(blocName, eventName, body);
      } else*/
      if (state.isNotEmpty) {
        context.expectMatch(context.world.getState(blocName), state.value);
      }
    },
  );
}
