import '../../domain/models/profile_model.dart';
import '../data_sources/profile_data_source.dart';

/// 1) Declare the interface your BLoC expects:
abstract class ProfileRepository {
  Future<Profile> getProfile(int userId);
  Future<Profile> updateProfile(int userId, Profile profile);
  Future<void> deleteProfile(int userId);
}

/// 2) Provide a concrete implementation:
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource dataSource;

  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<Profile> getProfile(int userId) {
    return dataSource.fetchProfile(userId);
  }

  @override
  Future<Profile> updateProfile(int userId, Profile profile) {
    return dataSource.updateProfile(userId, profile);
  }

  @override
  Future<void> deleteProfile(int userId) {
    return dataSource.deleteProfile(userId);
  }
}
