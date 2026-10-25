import 'package:date_app/features/global/models/user_model.dart';

class HomeUserCardModel {
  final String uid;
  final String name;
  final int? age;
  final String gender;
  final List<String> photos;
  final String bio;
  final String location;
  final String occupation;
  final bool isOnline;
  final UserModel rawUser;

  const HomeUserCardModel({
    required this.uid,
    required this.name,
    this.age,
    required this.gender,
    required this.photos,
    required this.bio,
    this.location = '',
    this.occupation = '',
    this.isOnline = false,
    required this.rawUser,
  });

  factory HomeUserCardModel.fromUserModel(UserModel user, {bool isOnline = false}) {
    final photoList = <String>[];
    if (user.profileImageUrl.isNotEmpty) {
      photoList.add(user.profileImageUrl);
    }

    int? calculatedAge;
    if (user.dob.isNotEmpty) {
      try {
        DateTime? dobDate;
        if (user.dob.contains('/')) {
          final parts = user.dob.split('/');
          if (parts.length == 3) {
            final day = int.tryParse(parts[0]);
            final month = int.tryParse(parts[1]);
            final year = int.tryParse(parts[2]);
            if (day != null && month != null && year != null) {
              dobDate = DateTime(year, month, day);
            }
          }
        } else {
          dobDate = DateTime.tryParse(user.dob);
        }

        if (dobDate != null) {
          final now = DateTime.now();
          calculatedAge = now.year - dobDate.year;
          if (now.month < dobDate.month ||
              (now.month == dobDate.month && now.day < dobDate.day)) {
            calculatedAge--;
          }
        }
      } catch (_) {}
    }

    return HomeUserCardModel(
      uid: user.uid,
      name: user.name.isNotEmpty ? user.name : 'Anonymous',
      age: calculatedAge,
      gender: user.gender,
      photos: photoList,
      bio: user.bio,
      isOnline: isOnline,
      rawUser: user,
    );
  }

  HomeUserCardModel copyWith({
    bool? isOnline,
  }) {
    return HomeUserCardModel(
      uid: uid,
      name: name,
      age: age,
      gender: gender,
      photos: photos,
      bio: bio,
      location: location,
      occupation: occupation,
      isOnline: isOnline ?? this.isOnline,
      rawUser: rawUser,
    );
  }
}
