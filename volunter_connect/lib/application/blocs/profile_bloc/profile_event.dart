
import '../../../domain/models/profile_model.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  final int userId;
  const LoadProfile(this.userId);
}

class UpdateProfile extends ProfileEvent {
  final Profile updated;
  const UpdateProfile(this.updated);
}

class DeleteProfile extends ProfileEvent {
  final int userId;
  const DeleteProfile(this.userId);
}
