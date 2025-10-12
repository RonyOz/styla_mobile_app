import 'package:styla_mobile_app/core/domain/model/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
}
