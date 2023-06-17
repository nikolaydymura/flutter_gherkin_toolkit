import 'package:flutter_gherkin_toolkit/src/steps/tap_steps.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tap on text hello', (){
    final step = TapOnTextStep();
    const input = 'tap on text `hello`';
    final matches = step.pattern.allMatches(input);
    expect(matches.length, 1);
    expect(matches.first.group(1), 'hello');
  });
}