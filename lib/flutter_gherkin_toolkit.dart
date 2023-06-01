library flutter_gherkin_toolkit;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gherkin/gherkin.dart';

class Calculator {
  final List<num> _cachedNumbers = <num>[];
  final List<String> _cachedCharacters = <String>[];
  final List<num> _results = <num>[];

  void storeNumericInput(num input) => _cachedNumbers.add(input);
  void storeCharacterInput(String input) => _cachedCharacters.add(input);

  num _retrieveNumericInput() => _cachedNumbers.removeAt(0);

  num add() {
    final result = _retrieveNumericInput() + _retrieveNumericInput();
    _results.add(result);

    return result;
  }

  num countStringCharacters() {
    num result = 0;
    for (var i = 0; i < _cachedCharacters[0].length; i += 1) {
      result += _cachedCharacters[0].codeUnitAt(i);
    }

    _cachedCharacters.clear();
    _results.add(result);

    return result;
  }

  num evaluateExpression(String expression) => 1;

  num getNumericResult() => _results.removeLast();

  void dispose() {
    _cachedNumbers.clear();
    _results.clear();
  }
}

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

abstract class CounterAction {
  const CounterAction();
}

class Increment extends CounterAction {
  const Increment();
}

class Decrement extends CounterAction {
  const Decrement();
}

class CDecrement extends CounterAction {
  final int value;
  const CDecrement(this.value);
}

class CounterBloc extends Bloc<CounterAction, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
    on<Decrement>((event, emit) => emit(state - 1));
  }
}

class CounterBlocWorld extends World {
  final CounterCubit counterCubit = CounterCubit();
  final CounterBloc counterBloc = CounterBloc();

  @override
  void dispose() {
    counterCubit.close();
  }
}

