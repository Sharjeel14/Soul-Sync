import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:date_app/core/constants/app_constants.dart';
import 'package:date_app/core/storage/storage_manager.dart';
import 'package:date_app/features/global/models/user_model.dart';

class AuthData {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const AuthData({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
}

@LazySingleton()
class AuthStorageService {
  static final AuthStorageService _instance = AuthStorageService._internal();
  factory AuthStorageService() => _instance;
  AuthStorageService._internal();

  final StorageManager _storage = StorageManager();

  static const String _keyToken = StorageKeys.userToken;
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUser = 'user_data';

  Future<void> saveAuthData(AuthData data) async {
    if (data.accessToken.isNotEmpty) {
      await _storage.write(_keyToken, data.accessToken);
    }
    if (data.refreshToken.isNotEmpty) {
      await _storage.write(_keyRefreshToken, data.refreshToken);
    }
    await saveUser(data.user);
  }

  Future<AuthData?> getAuthData() async {
    final accessToken = await _storage.read(_keyToken);
    final refreshToken = await _storage.read(_keyRefreshToken);
    final user = await getUser();

    if ((accessToken == null || accessToken.isEmpty) &&
        (refreshToken == null || refreshToken.isEmpty) &&
        user == null) {
      return null;
    }

    return AuthData(
      accessToken: accessToken ?? '',
      refreshToken: refreshToken ?? '',
      user: user ?? UserModel.empty(),
    );
  }

  Future<void> saveUser(UserModel user) async {
    await _storage.write(_keyUser, jsonEncode(user.toJson()));
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(_keyToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(_keyRefreshToken);
  }

  Future<void> saveAccessRefereshToken(
    String accessToken,
    String refreshToken,
  ) async {
    await _storage.write(_keyToken, accessToken);
    await _storage.write(_keyRefreshToken, refreshToken);
  }

  Future<void> saveAccessToken(String token) async {
    await _storage.write(_keyToken, token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(_keyRefreshToken, token);
  }

  Future<UserModel?> getUser() async {
    final userStr = await _storage.read(_keyUser);
    if (userStr != null) {
      try {
        return UserModel.fromJson(jsonDecode(userStr));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    return await _storage.containsKey(_keyToken);
  }

  Future<void> logout() async {
    await _storage.delete(_keyToken);
    await _storage.delete(_keyRefreshToken);
    await _storage.delete(_keyUser);
  }
}
