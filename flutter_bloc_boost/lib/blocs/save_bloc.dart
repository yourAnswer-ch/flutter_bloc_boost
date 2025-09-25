import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_boost/blocs/events/base_event.dart';
import 'package:flutter_bloc_boost/blocs/states/base_state.dart';
import 'package:flutter_bloc_boost/blocs/states/error_state.dart';

abstract class SaveBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  SaveBloc(super.initialState);
  
  bool get isRunning => _isRunning;  
  bool _isRunning = false;

  @override
  void on<E extends Event>(
    EventHandler<E, State> handler, {
    EventTransformer<E>? transformer,
  }) {
    super.on<E>((e, s) => _runSave<E>(e, s, handler), transformer: transformer);
  }

  Future _runSave<T extends Event>(
      T event, Emitter<State> emit, EventHandler<T, State> handler) async {
    try {
      await handler(event, emit);
    } catch (error) {
      emit(ErrorState(error) as State);
    }
  }
    
  Future<void> runExclusive(Function functionToExecute) async {
    if (_isRunning) return;

    _isRunning = true;
    try {
      await functionToExecute();
    } finally {
      _isRunning = false;
    }
  }
}
