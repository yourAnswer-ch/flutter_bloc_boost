import 'package:flutter_bloc_boost/blocs/states/base_state.dart';

class PageableListState<T> extends BaseState {
  PageableListState({
    required this.list, 
    required this.page, 
    required this.pageSize});

  final List<T> list;
  final int page;
  final int pageSize;
}