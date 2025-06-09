
import '../../../domain/models/profile_model.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  const ProfileLoaded(this.profile);
}

class ProfileUpdated extends ProfileState {
  final Profile profile;
  const ProfileUpdated(this.profile);
}

class ProfileDeleted extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}
