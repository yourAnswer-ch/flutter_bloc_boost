import 'package:flutter_bloc_boost/blocs/events/base_event.dart';

class LoadById extends BaseEvent {
  LoadById({required this.id});

  final String id;
}
