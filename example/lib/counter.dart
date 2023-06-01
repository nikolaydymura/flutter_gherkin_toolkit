library flutter_gherkin_toolkit;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gherkin/gherkin.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);

  void decrement() => emit(state - 1);
}

abstract class CounterEvent {
  const CounterEvent();
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent();
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent();
}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<IncrementEvent>((event, emit) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      emit(state + 1);
    });
    on<DecrementEvent>((event, emit) => emit(state - 1));
  }
}
