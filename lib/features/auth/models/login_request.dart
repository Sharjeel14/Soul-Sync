
class LoginRequest {
  final String identifier;

  LoginRequest({required this.identifier});

  Map<String, dynamic> toJson([String? deviceId, String? fcmToken]) {
    return {
      'identifier': identifier,
      "type": "Customer",
      "DeviceID": deviceId,
      "FCMToken": fcmToken,
    };
  }
}
