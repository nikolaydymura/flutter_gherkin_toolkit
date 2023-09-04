import 'package:flutter_gherkin_toolkit/src/utils/string.dart';
import 'package:gherkin/gherkin.dart';

abstract class EventParameter<T> extends CustomParameter<T> {
  static final RegExp _params = RegExp(r'''["`']?(\w+)\((.*)\)["`']?''');

  EventParameter(
      List<Type> events, T Function(String, [dynamic args]) transformEvent,
      {String separator = ',', String prefix = ''})
      : super(
          '$prefix$T'.toUpperCase(),
          RegExp(r'''["`']?((?:'''
              '${events.join('|')}'
              ''')\((?:.*)\))["`']?'''),
          (input) {
            final match = _params.firstMatch(input)!;
            final args =
                match.group(2)?.split(separator).map((e) => e.value).toList() ??
                    [];
            return transformEvent(match.group(1)!, args);
          },
        );
}
