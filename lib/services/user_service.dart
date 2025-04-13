import 'package:hive_flutter/hive_flutter.dart';
import 'package:mkatabafix_app/models/user_profile_model.dart'; // Assuming this path
import 'dart:typed_data';

class UserService {
  Future<UserProfile?> getUserProfile() async {
    final userProfileBox = Hive.box<UserProfile>('userProfileBox');
    return userProfileBox.get('user');
  }

  Future<void> saveUserProfile({required String fullName, Uint8List? profileImage}) async {
    final userProfileBox = Hive.box<UserProfile>('userProfileBox');
    final userProfile = UserProfile(fullName: fullName, profileImage: profileImage);
    await userProfileBox.put('user', userProfile);
  }

  // You might add functions to update or delete user data later
}