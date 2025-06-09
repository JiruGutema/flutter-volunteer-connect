// application/blocs/event_creation_bloc/event_creation_event.dart
part of 'event_creation_bloc.dart';

abstract class EventCreationEvent extends Equatable {
  const EventCreationEvent();

  @override
  List<Object> get props => [];
}

class CreateEventRequested extends EventCreationEvent {
  final Event event;
  final String token;

  const CreateEventRequested({required this.event, required this.token});

  @override
  List<Object> get props => [event, token];
}