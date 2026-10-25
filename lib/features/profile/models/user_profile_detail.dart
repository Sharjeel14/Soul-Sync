import 'package:equatable/equatable.dart';
import 'package:date_app/core/enums/gender.dart';
import 'package:date_app/features/global/models/user_model.dart';

class UserProfileDetail extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final GenderType gender;
  final String profileImageUrl;
  final String bio;
  final String dob;
  final bool isEmailVerified;
  final int matchesCount;
  final int likesCount;

  const UserProfileDetail({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.profileImageUrl,
    this.bio = '',
    this.dob = '',
    this.isEmailVerified = false,
    this.matchesCount = 0,
    this.likesCount = 0,
  });

  bool get isGuest => uid.isEmpty;

  factory UserProfileDetail.fromUserModel(
    UserModel user, {
    int matchesCount = 0,
    int likesCount = 0,
  }) {
    final parsedGender = GenderType.values.firstWhere(
      (g) => g.name.toLowerCase() == user.gender.toLowerCase(),
      orElse: () => GenderType.male,
    );

    return UserProfileDetail(
      uid: user.uid,
      name: user.name,
      email: user.email,
      phone: user.phone,
      gender: parsedGender,
      profileImageUrl: user.profileImageUrl,
      bio: user.bio,
      dob: user.dob,
      isEmailVerified: user.isEmailVerified,
      matchesCount: matchesCount,
      likesCount: likesCount,
    );
  }

  UserModel toUserModel() {
    return UserModel(
      uid: uid,
      name: name,
      email: email,
      phone: phone,
      gender: gender.name,
      profileImageUrl: profileImageUrl,
      bio: bio,
      dob: dob,
      isEmailVerified: isEmailVerified,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        phone,
        gender,
        profileImageUrl,
        bio,
        dob,
        isEmailVerified,
        matchesCount,
        likesCount,
      ];
}
