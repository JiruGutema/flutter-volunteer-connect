import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:volunter_connect/application/blocs/profile_bloc/profile_event.dart';
import 'package:volunter_connect/application/blocs/profile_bloc/profile_state.dart';
import '../../../domain/models/profile_model.dart';
import '../../../infrastructure/repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteProfile>(_onDeleteProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getProfile(event.userId);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event,
      Emitter<ProfileState> emit,
      ) async {
    // 1) grab the old profile first:
    if (state is! ProfileLoaded) return;
    final oldProfile = (state as ProfileLoaded).profile;

    // 2) now enter loading
    emit(ProfileLoading());

    try {
      // 3) use oldProfile.id, not re‐casting state
      final updated =
      await repository.updateProfile(oldProfile.id, event.updated);

      emit(ProfileUpdated(updated));
      emit(ProfileLoaded(updated));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }


  Future<void> _onDeleteProfile(
      DeleteProfile event,
      Emitter<ProfileState> emit,
      ) async {
    // You already have event.userId so you don't need state
    emit(ProfileLoading());
    try {
      await repository.deleteProfile(event.userId);
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

}
