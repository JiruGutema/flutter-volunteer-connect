// infrastructure/repositories/event_repository.dart

import 'package:volunter_connect/domain/models/event_model.dart';
import 'package:volunter_connect/infrastructure/data_sources/event_creation_data_source.dart';

class EventRepository {
  final EventDataSource eventDataSource;

  EventRepository({required this.eventDataSource});

  Future<Event> createEvent(Event event, String token) async {
    try {
      final response = await eventDataSource.createEvent(event, token);
      return Event.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  getEvents() {}
}
