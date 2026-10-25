import 'package:equatable/equatable.dart';
import 'package:date_app/features/global/models/user_model.dart';

class BlockedUserItem extends Equatable {
  final String uid;
  final String name;
  final String profileImageUrl;
  final UserModel rawUser;

  const BlockedUserItem({
    required this.uid,
    required this.name,
    required this.profileImageUrl,
    required this.rawUser,
  });

  factory BlockedUserItem.fromUserModel(UserModel user) {
    return BlockedUserItem(
      uid: user.uid,
      name: user.name.isNotEmpty ? user.name : 'Blocked User',
      profileImageUrl: user.profileImageUrl,
      rawUser: user,
    );
  }

  @override
  List<Object?> get props => [uid, name, profileImageUrl];
}
