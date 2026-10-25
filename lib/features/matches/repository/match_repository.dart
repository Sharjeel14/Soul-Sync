import 'package:date_app/features/global/models/user_model.dart';

abstract class MatchRepository {
  Future<void> saveMatch(UserModel targetUser);
  Future<List<UserModel>> getMatches();
  Stream<List<UserModel>> streamMatches();
  bool isMatched(String userId);
}
