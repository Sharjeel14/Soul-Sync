import 'package:equatable/equatable.dart';
import 'package:date_app/features/global/models/user_model.dart';

class MatchItemModel extends Equatable {
  final String id;
  final String userId;
  final String targetUid;
  final DateTime? matchedAt;
  final UserModel user;

  const MatchItemModel({
    required this.id,
    required this.userId,
    required this.targetUid,
    this.matchedAt,
    required this.user,
  });

  factory MatchItemModel.fromSupabase(Map<String, dynamic> json) {
    UserModel user;
    if (json['matched_user'] != null && json['matched_user'] is Map<String, dynamic>) {
      user = UserModel.fromJson(json['matched_user'] as Map<String, dynamic>);
    } else {
      user = UserModel(
        uid: (json['target_uid'] ?? '').toString(),
        name: (json['name'] ?? 'User').toString(),
        email: '',
        phone: '',
        gender: 'male',
        profileImageUrl: (json['profile_image_url'] ?? '').toString(),
      );
    }

    DateTime? matchedAt;
    if (json['created_at'] != null) {
      matchedAt = DateTime.tryParse(json['created_at'].toString());
    }

    return MatchItemModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      targetUid: (json['target_uid'] ?? user.uid).toString(),
      matchedAt: matchedAt,
      user: user,
    );
  }

  factory MatchItemModel.fromUser(UserModel user) {
    return MatchItemModel(
      id: user.uid,
      userId: '',
      targetUid: user.uid,
      matchedAt: DateTime.now(),
      user: user,
    );
  }

  @override
  List<Object?> get props => [id, userId, targetUid, matchedAt, user.uid];
}
