// application/blocs/events_bloc/events_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/models/event_model.dart';
import './../../infrastructure/repositories/event_repository.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository eventsRepository;

  EventsBloc({required this.eventsRepository}) : super(EventsInitial()) {
    on<LoadEvents>(_onLoadEvents);
  }

  Future<void> _onLoadEvents(
    LoadEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(EventsLoading());
    try {
      final events = await eventsRepository.getEvents();
      emit(EventsLoaded(events: events));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }
}