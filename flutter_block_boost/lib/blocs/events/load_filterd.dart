import 'package:flutter_block_boost/blocs/events/base_event.dart';

class LoadFilterd<T> extends BaseEvent {
  LoadFilterd(this.filter);
  
  final T filter;
}