// application/blocs/event_creation_bloc/event_creation_state.dart
part of 'event_creation_bloc.dart';

abstract class EventCreationState extends Equatable {
  const EventCreationState();

  @override
  List<Object> get props => [];
}

class EventCreationInitial extends EventCreationState {}

class EventCreationLoading extends EventCreationState {}

class EventCreationSuccess extends EventCreationState {
  final Event event;

  const EventCreationSuccess({required this.event});

  @override
  List<Object> get props => [event];
}

class EventCreationFailure extends EventCreationState {
  final String error;

  const EventCreationFailure({required this.error});

  @override
  List<Object> get props => [error];
}