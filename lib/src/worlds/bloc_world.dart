import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gherkin/gherkin.dart';
import 'package:meta/meta.dart';
import 'package:get_it/get_it.dart';

class MultiBlocWorld extends World {
  final List<BlocBaseWorld> _blocs;

  MultiBlocWorld(this._blocs);

  @override
  void setAttachmentManager(AttachmentManager attachmentManager) {
    super.setAttachmentManager(attachmentManager);
    for (final b in _blocs) {
      b.setAttachmentManager(attachmentManager);
    }
  }

  void addEvent(String type, String eventType, [dynamic args]) {
    final bloc = _blocs.firstWhere((e) => e.typeName == type) as BlocWorld;
    bloc.addEvent(eventType, args);
  }

  void addEventPayload(
      String type, String eventType, Map<dynamic, dynamic> payload) {
    final bloc = _blocs.firstWhere((e) => e.typeName == type) as BlocWorld;
    bloc.addEvent(eventType);
  }

  dynamic getState(String type) {
    final bloc = _blocs.firstWhere((e) => e.typeName == type);
    return bloc.states.last;
  }

  @override
  void dispose() {
    for (final b in _blocs) {
      b.dispose();
    }
  }
}

abstract class BlocBaseWorld<State> extends World {
  final List<State> states = <State>[];
  late final BlocBase<State> _bloc = _createBloc();
  StreamSubscription<State>? _subscription;

  String get typeName => _bloc.runtimeType.toString();

  BlocBase<State> build();

  BlocBase<State> _createBloc() {
    final bloc = build();
    _subscription = bloc.stream.listen(states.add);
    return bloc;
  }

  void seed(State state) {
    final target = _bloc;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    target.emit(state);
  }

  FutureOr<void> invokeMethod(String name, [dynamic args]);

  @override
  void dispose() {
    _subscription?.cancel();
    _bloc.close();
    super.dispose();
  }
}

abstract class BlocWorld<Event, State> extends BlocBaseWorld<State> {
  void addEvent(String name, [dynamic args]) {
    final target = _bloc as Bloc<Event, State>;
    target.add(mapEvent(name, args));
  }

  Event mapEvent(String name, [dynamic args]);
}
