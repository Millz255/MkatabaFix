import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'user_profile_model.g.dart';

@HiveType(typeId: 1)
class UserProfile {
  @HiveField(0)
  final String fullName;
  @HiveField(1)
  final Uint8List? profileImage;

  UserProfile({
    required this.fullName,
    this.profileImage,
  });
}