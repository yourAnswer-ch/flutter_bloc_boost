import 'package:flutter_bloc_boost/blocs/states/base_state.dart';

class DataState<T> extends BaseState {
  DataState(this.data);

  final T data;
}
