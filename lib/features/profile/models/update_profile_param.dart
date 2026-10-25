import 'dart:io';
import 'package:date_app/core/enums/gender.dart';

class UpdateProfileParam {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final GenderType gender;
  final File? newProfileImage;

  const UpdateProfileParam({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.newProfileImage,
  });
}
