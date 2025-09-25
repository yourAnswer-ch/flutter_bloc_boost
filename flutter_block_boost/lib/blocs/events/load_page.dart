import 'package:flutter_block_boost/blocs/events/base_event.dart';

class LoadPage extends BaseEvent {
  LoadPage({required this.page, this.pageSize});

  final int page;
  final int? pageSize;
}