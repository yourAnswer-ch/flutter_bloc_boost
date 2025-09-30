import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_boost/blocs/states/error_state.dart';
import 'package:flutter_bloc_boost/flutter_bloc_boost.dart';

typedef BlocWidgetBuilder<S> = Widget Function(BuildContext context, S state);

class StateBuilder<T extends BaseState> {
  StateBuilder({required this.builder});

  final Type type = T;
  final BlocWidgetBuilder<T> builder;

  Widget _call(BuildContext context, BaseState state) {
    return builder(context, state as T);
  }
}

@immutable
class BlocStateBuilder<TBloc extends StateStreamable<BaseState>>
    extends StatelessWidget {
  BlocStateBuilder({super.key, required Iterable<StateBuilder> builders}) {
    _handlers[LoadingState] = StateBuilder<LoadingState>(builder: onLoading);
    _handlers[NoContentState] = StateBuilder<NoContentState>(builder: onNoData);
    _handlers[ErrorState] = StateBuilder<ErrorState>(builder: onError);

    for (var builder in builders) {
      _handlers[builder.type] = builder;
    }
  }

  final Map<Type, StateBuilder> _handlers = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TBloc, BaseState>(builder: (context, state) {
      var handler = _handlers[state.runtimeType];
      if (handler != null) {
        log("CustomBlocBuilder: handling state ${state.runtimeType}");
        return handler._call(context, state);
      }

      return onUnknownSate(context, state);
    });
  }

  Widget onLoading(BuildContext context, LoadingState state) {
    return const Center(
      child: CircularProgressIndicator(semanticsLabel: "Loading"),
    );
  }

  Widget onNoData(BuildContext context, NoContentState state) {
    return const Center(
      child: Text("No data loaded"),
    );
  }

  Widget onError(BuildContext context, ErrorState state) {
    return Text(state.error.toString());    
  }

  Widget onUnknownSate(BuildContext context, BaseState state) {
    String type = state.runtimeType.toString();
    return Center(
      child: Text('Error: state type $type is not defined'),
    );
  }
}
