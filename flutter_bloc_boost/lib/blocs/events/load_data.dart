import 'package:flutter_bloc_boost/blocs/events/base_event.dart';

class LoadData extends BaseEvent {
  LoadData({required this.page, required this.pageSize});

  final int page;
  final int pageSize;
}
