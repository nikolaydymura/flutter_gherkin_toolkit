import 'package:gherkin/gherkin.dart';

class BlocParameter extends CustomParameter<String> {
  BlocParameter()
      : super(
          'BLOC',
          RegExp(r'''["`']?([A-Z][_$A-Za-z0-9]+(?:Bloc|Cubit))["`']?'''),
          (input) {
            return input.trim();
          },
        );
}
