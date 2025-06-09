// application/blocs/event_creation_bloc/event_creation_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:volunter_connect/domain/models/event_model.dart';
import 'package:volunter_connect/infrastructure/repositories/event_creation_repository.dart';

part 'event_creation_event.dart';
part 'event_creation_state.dart';

class EventCreationBloc extends Bloc<EventCreationEvent, EventCreationState> {
  final EventRepository eventRepository;

  EventCreationBloc({required this.eventRepository}) : super(EventCreationInitial()) {
    on<CreateEventRequested>(_onCreateEventRequested);
  }

  Future<void> _onCreateEventRequested(
    CreateEventRequested event,
    Emitter<EventCreationState> emit,
  ) async {
    emit(EventCreationLoading());
    try {
      final createdEvent = await eventRepository.createEvent(
        event.event,
        event.token,
      );
      emit(EventCreationSuccess(event: createdEvent));
    } catch (e) {
      emit(EventCreationFailure(error: e.toString()));
    }
  }
}