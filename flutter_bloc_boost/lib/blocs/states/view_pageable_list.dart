import 'package:flutter_bloc_boost/blocs/states/base_state.dart';

class ViewPageableList<T> extends BaseState {
  ViewPageableList({
    required this.list, 
    required this.page, 
    required this.pageSize});

  final List<T> list;
  final int page;
  final int pageSize;
}