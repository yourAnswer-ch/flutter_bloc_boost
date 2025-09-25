import 'package:flutter_bloc_boost/blocs/states/base_state.dart';

class ErrorState extends BaseState {
  final Object error;
  ErrorState(this.error);
}
