import 'package:date_app/core/constants/app_constants.dart';
import 'package:date_app/core/enums/gender.dart';

class SignupRequest {
  // final String nationalId;
  final String name;
  final String mobile;
  final String dob;
  final GenderType gender;

  SignupRequest({
    // required this.nationalId,
    required this.name,
    required this.mobile,
    required this.dob,
    required this.gender,
  });

  Map<String, dynamic> toJson([String? deviceId, String? fcmToken]) {
    return {
      "FullName": name,
      "Mobile": mobile,
      "DOB": dob,
      "CountryCode": AppCountryCodes.ksa,
      "DeviceID": deviceId,
      "FCMToken": fcmToken,
      "GenderID": gender == GenderType.unknown
          ? 0
          : gender == GenderType.male
          ? 1
          : 2,
    };
  }
}
