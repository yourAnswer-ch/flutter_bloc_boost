import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_boost/blocs/events/load_by_id.dart';
import 'package:flutter_bloc_boost/blocs/events/load_data.dart';
import 'package:flutter_bloc_boost/blocs/events/load_page.dart';
import 'package:flutter_bloc_boost/blocs/events/refresh_data.dart';
import 'package:flutter_bloc_boost/blocs/pageable_list.dart';
import 'package:flutter_bloc_boost/blocs/save_bloc.dart';
import 'package:flutter_bloc_boost/blocs/states/loading_state.dart';
import 'package:flutter_bloc_boost/blocs/states/pageable_list_state.dart';
import 'package:stream_transform/stream_transform.dart';


abstract class PageableListBloc<T> extends SaveBloc {
  PageableListBloc(super.initialState) {
    on<LoadData>(loadData);
    on<LoadById>(loadById);
    on<RefreshData>(refreshData);
    on<LoadPage>(loadPage,    
        transformer: (events, mapper) => events
      .debounce(const Duration(milliseconds: 500), leading: true, trailing: false)
      .asyncExpand(mapper));
  }

  int defaultPageSize = 40;

  void startLoading() {
    if (!isRunning) {
      add(LoadData(page: 1, pageSize: 40));
    }
  }

  void loadNextPage() {
    if (!isRunning && !list.endOfList) {
      add(LoadPage(page: list.page + 1, pageSize: defaultPageSize));
    }
  }

  void refresh() {
    if (!isRunning) {
      add(RefreshData());
    }
  }

  void selectItem(T item){
    _selectedItem = item;
    _itemSelectedController.add(item);
  }

  void clearselection(){
    _selectedItem = null;
    _itemSelectedController.add(null);
  }

  final PageableList<T> list = PageableList();
  
  T? get selectedItem => _selectedItem;
  T? _selectedItem;

  // Broadcast stream for item selection events
  final StreamController<T?> _itemSelectedController = StreamController<T?>.broadcast();
  Stream<T?> get itemSelectedStream => _itemSelectedController.stream;

  @protected
  Future loadData(LoadData event, Emitter emit) async {
    emit(LoadingState());
    await callBackend(1, defaultPageSize, emit);
  }

  @protected
  Future loadPage(LoadPage event, Emitter emit) async {
    if(list.endOfList || list.page == event.page) {
      return; // No need to load the same page again
    }

    await callBackend(event.page, event.pageSize ?? defaultPageSize, emit);
  }

  @protected
  Future refreshData(RefreshData event, Emitter emit) async{
    emit(LoadingState());
    await callBackend(1, defaultPageSize, emit);
  }
  
  @protected
  Future loadById(LoadById event, Emitter emit);

  @protected
  Future callBackend(int page, int pageSize, Emitter emit);

  // @protected
  // void 

  @protected
  void emitCurrentList(Emitter emit) {
    emit(PageableListState<T>(
        list: list, page: list.page, pageSize: list.pageSize));
  }

  @override
  Future<void> close() {
    _itemSelectedController.close();
    return super.close();
  }
}
