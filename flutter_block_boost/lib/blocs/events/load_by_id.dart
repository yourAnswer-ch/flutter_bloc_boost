import 'package:flutter_block_boost/blocs/events/base_event.dart';

class LoadById extends BaseEvent {
  LoadById({required this.id});

  final String id;
}
