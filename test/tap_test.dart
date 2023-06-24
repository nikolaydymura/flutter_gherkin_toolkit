import 'package:flutter_gherkin_toolkit/src/steps/tap_steps.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tap on text hello', () {
    final step = TapOnTextStep();
    const input = 'tap on text `hello`';
    final matches = step.pattern.allMatches(input);
    expect(matches.length, 1);
    expect(matches.first.group(2), 'hello');
  });

  test('tap on text hello last', () {
    final step = TapOnTextStep();
    const input1 = 'tap on text `hello`->last';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(2), 'hello');
    expect(matches.first.group(3), 'last');
  });

  test('tap on text hello first', () {
    final step = TapOnTextStep();
    const input1 = 'tap on text `hello`->first';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(2), 'hello');
    expect(matches.first.group(3), 'first');
  });

  test('tap on text hello 12', () {
    final step = TapOnTextStep();
    const input1 = 'tap on text `hello`->12';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(2), 'hello');
    expect(matches.first.group(3), '12');
  });

  test('tap on text hello in TextButton', () {
    final step = TapOnTextStep();
    const input1 = 'tap on text TextButton->`hello`';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(1), 'TextButton');
    expect(matches.first.group(2), 'hello');
  });

  test('tap on text hello in TextButton at 4', () {
    final step = TapOnTextStep();
    const input1 = 'tap on text TextButton->`hello`->4';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(1), 'TextButton');
    expect(matches.first.group(2), 'hello');
    expect(matches.first.group(3), '4');
  });

  test('tap on icon Icons.add', () {
    final step = TapOnIconsStep();
    const input = 'tap on icon `Icons.add`';
    final matches = step.pattern.allMatches(input);
    expect(matches.length, 1);
    expect(matches.first.group(2), 'Icons.add');
  });

  test('tap on icon Icons.add 12', () {
    final step = TapOnIconsStep();
    const input1 = 'tap on icon `Icons.add`->12';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(2), 'Icons.add');
    expect(matches.first.group(3), '12');
  });

  test('tap on icon Icons.add last', () {
    final step = TapOnIconsStep();
    const input1 = 'tap on icon `Icons.add`->last';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(2), 'Icons.add');
    expect(matches.first.group(3), 'last');
  });

  test('tap on icon Icons.add first', () {
    final step = TapOnIconsStep();
    const input1 = 'tap on icon `Icons.add`->first';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(2), 'Icons.add');
    expect(matches.first.group(3), 'first');
  });

  test('tap on icon Icons.add in TextButton', () {
    final step = TapOnIconsStep();
    const input1 = 'tap on icon TextButton->`Icons.add`';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(1), 'TextButton');
    expect(matches.first.group(2), 'Icons.add');
  });

  test('tap on on icon Icons.add in TextButton at 4', () {
    final step = TapOnIconsStep();
    const input1 = 'tap on icon TextButton->`Icons.add`->4';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(1), 'TextButton');
    expect(matches.first.group(2), 'Icons.add');
    expect(matches.first.group(3), '4');
  });

  test('tap on on icon Icons.add in TextButton first', () {
    final step = TapOnIconsStep();
    const input1 = 'tap on icon TextButton->`Icons.add`->first';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(1), 'TextButton');
    expect(matches.first.group(2), 'Icons.add');
    expect(matches.first.group(3), 'first');
  });

  test('tap on on icon Icons.add in TextButton last', () {
    final step = TapOnIconsStep();
    const input1 = 'tap on icon TextButton->`Icons.add`->last';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(1), 'TextButton');
    expect(matches.first.group(2), 'Icons.add');
    expect(matches.first.group(3), 'last');
  });

  test('tap on widget TextButton', () {
    final step = TapOnWidgetStep();
    const input = 'tap on widget TextButton';
    final matches = step.pattern.allMatches(input);
    expect(matches.length, 1);
    expect(matches.first.group(2), 'TextButton');
  });

  test('tap on widget TextButton 12', () {
    final step = TapOnWidgetStep();
    const input1 = 'tap on widget TextButton->12';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(2), 'TextButton');
    expect(matches.first.group(3), '12');
  });

  test('tap on widget TextButton first', () {
    final step = TapOnWidgetStep();
    const input1 = 'tap on widget TextButton->first';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(2), 'TextButton');
    expect(matches.first.group(3), 'first');
  });

  test('tap on widget TextButton in Container', () {
    final step = TapOnWidgetStep();
    const input1 = 'tap on widget Container->TextButton';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(1), 'Container');
    expect(matches.first.group(2), 'TextButton');
  });

  test('tap on widget TextButton in Container first', () {
    final step = TapOnWidgetStep();
    const input1 = 'tap on widget Container->TextButton->first';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(1), 'Container');
    expect(matches.first.group(2), 'TextButton');
    expect(matches.first.group(3), 'first');
  });

  test('tap on image "assets/images/arrow_back.svg"', () {
    final step = TapOnImageStep();
    const input = 'tap on image `assets/images/arrow_back.svg`';
    final matches = step.pattern.allMatches(input);
    expect(matches.length, 1);
    expect(
        matches.first.group(2), 'assets/images/arrow_back.svg');
  });

  test('tap on image "assets/images/arrow_back.svg" last', () {
    final step = TapOnImageStep();
    const input1 =
        'tap on image `assets/images/arrow_back.svg`->last';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(
        matches.first.group(2), 'assets/images/arrow_back.svg');
    expect(matches.first.group(3), 'last');
  });

  test('tap on image "assets/images/arrow_back.svg" first', () {
    final step = TapOnImageStep();
    const input1 =
        'tap on image `assets/images/arrow_back.svg`->first';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(
        matches.first.group(2), 'assets/images/arrow_back.svg');
    expect(matches.first.group(3), 'first');
  });

  test('tap on image "assets/images/arrow_back.svg" 8', () {
    final step = TapOnImageStep();
    const input1 =
        'tap on image `assets/images/arrow_back.svg`->8';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(
        matches.first.group(2), 'assets/images/arrow_back.svg');
    expect(matches.first.group(3), '8');
  });

  test('tap on image "assets/images/arrow_back.svg" in TextButton', () {
    final step = TapOnImageStep();
    const input1 =
        'tap on image TextButton->`assets/images/arrow_back.svg`';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(1), 'TextButton');
    expect(
        matches.first.group(2), 'assets/images/arrow_back.svg');
  });

  test('tap on image "assets/images/arrow_back.svg" in TextButton 4', () {
    final step = TapOnImageStep();
    const input1 =
        'tap on image TextButton->`assets/images/arrow_back.svg`->4';
    final matches = step.pattern.allMatches(input1);
    expect(matches.length, 1);
    expect(matches.first.group(1), 'TextButton');
    expect(
        matches.first.group(2), 'assets/images/arrow_back.svg');
    expect(matches.first.group(3), '4');
  });
}