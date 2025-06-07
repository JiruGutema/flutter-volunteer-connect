// infrastructure/repositories/events_repository.dart
import 'package:volunter_connect/infrastructure/data_sources/events_data_source.dart';

import '../../domain/models/event_model.dart';

class EventsRepository {
  final EventsDataSource eventsDataSource;

  EventsRepository({required this.eventsDataSource});

  Future<List<Event>> getEvents() async {
    try {
      final response = await eventsDataSource.getEvents();
      return (response['events'] as List)
          .map((event) => Event.fromJson(event))
          .toList();
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }
}