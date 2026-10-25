import 'package:date_app/features/global/models/user_model.dart';

abstract class BlockRepository {
  Future<void> blockUser(String blockedUid);
  Future<void> unblockUser(String blockedUid);
  Future<List<UserModel>> getBlockedUsers();
  Stream<List<UserModel>> streamBlockedUsers();
  Future<Set<String>> getBlockedUserIds();
  bool isBlocked(String uid);
}
