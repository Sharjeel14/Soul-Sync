import 'dart:convert';
import 'dart:developer' as log;
import 'dart:io';
// import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:date_app/core/extensions/context_language_extension.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void closeKeyboard() async {
  try {
    FocusManager.instance.primaryFocus?.unfocus();
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<String?> reverseGeocode(LatLng latLng, String apiKey) async {
  final url =
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey';

  try {
    final res = await http.get(Uri.parse(url));
    final data = json.decode(res.body);
    if (data['results'] != null && (data['results'] as List).isNotEmpty) {
      return data['results'][0]['formatted_address'] as String;
    }
  } catch (e) {
    log.log('Reverse geocode error: $e');
  }
  return null;
}

int parseInt(dynamic value, {int fallback = 0}) {
  if (value == null) return fallback;

  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is bool) return value ? 1 : 0;

  return int.tryParse(value.toString()) ?? fallback;
}

double parseDouble(dynamic value, {double fallback = 0.0}) {
  if (value == null) return fallback;

  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is bool) return value ? 1.0 : 0.0;

  return double.tryParse(value.toString()) ?? fallback;
}

String convertDate({String? input}) {
  if (input == null || input == '') {
    return '';
  }

  final inputFormat = DateFormat('dd/MM/yyyy');
  final outputFormat = DateFormat('yyyy-MM-dd');

  final date = inputFormat.parse(input);
  return outputFormat.format(date);
}

String formatDate(dynamic input) {
  if (input == null || input == '') {
    return '';
  }

  DateTime date;

  if (input is DateTime) {
    date = input;
  } else if (input is String) {
    date = DateTime.parse(input);
  } else {
    throw ArgumentError('Input must be a String or DateTime');
  }

  return DateFormat('dd/MM/yyyy').format(date);
}

Future<PermissionStatus> requestPhotosPermission() async {
  PermissionStatus status;

  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    int sdkInt = int.tryParse(androidInfo.version.release) ?? 0;

    if (sdkInt >= 13) {
      status = await Permission.photos.request(); // Android 13+
    } else {
      status = await Permission.storage.request(); // Android < 13
    }
  } else if (Platform.isIOS) {
    status = await Permission.storage.request();
  } else {
    // Other platforms (Web, macOS, etc.)
    return PermissionStatus.granted;
  }

  return status;
}

Future<ImageSource?> showImagePickerSource(BuildContext context) async {
  return await showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: AppColors.backgroundDark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
    ),
    builder: (context) => const ImagePickerBottomSheet(),
  );
}

String formatOrderDate(dynamic dateTime, bool isArabic) {
  if (dateTime == null) return '';

  DateTime? date;

  if (dateTime is DateTime) {
    date = dateTime;
  } else if (dateTime is String) {
    date = DateTime.tryParse(dateTime);
  }

  if (date == null) return '';

  return DateFormat(
    isArabic ? 'd MMMM y' : 'MMM d, y',
    isArabic ? 'ar' : 'en',
  ).format(date);
}

String formatOrderTime(DateTime dateTime, bool isArabic) {
  return DateFormat('h:mm a', isArabic ? 'ar' : 'en').format(dateTime);
}

String memberSinceLocalized(BuildContext context, String dateString) {
  final date = DateTime.tryParse(dateString) ?? DateTime.now();

  if (context.isArabic) {
    return 'عضو منذ ${DateFormat('MMM yyyy', 'ar').format(date)}';
  }

  return 'Member since ${DateFormat('MMM yyyy', 'en').format(date)}';
}

Future<String?> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Android hardware serial / build ID
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // UUID unique per app + vendor
    } else if (Platform.isWindows) {
      final windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId;
    } else if (Platform.isMacOS) {
      final macInfo = await deviceInfo.macOsInfo;
      return macInfo.systemGUID;
    } else if (Platform.isLinux) {
      final linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.machineId;
    }
  } catch (e) {
    debugPrint('Failed to get device ID: $e');
  }

  return null;
}

// /// Haversine formula — returns distance in meters
// double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//   const double earthRadiusMeters = 6371000;

//   final double dLat = _degreesToRadians(lat2 - lat1);
//   final double dLon = _degreesToRadians(lon2 - lon1);

//   final double a =
//       sin(dLat / 2) * sin(dLat / 2) +
//       cos(_degreesToRadians(lat1)) *
//           cos(_degreesToRadians(lat2)) *
//           sin(dLon / 2) *
//           sin(dLon / 2);

//   final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

//   return earthRadiusMeters * c;
// }

// double _degreesToRadians(double degrees) => degrees * (pi / 180);

String convertTimingToArabic(String timing) {
  if (timing.trim().isEmpty) return timing;

  // If it already contains Arabic characters/digits, assume it's Arabic.
  final arabicPattern = RegExp(r'[\u0600-\u06FF]');
  if (arabicPattern.hasMatch(timing)) {
    return timing;
  }

  const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  String result = timing;

  // Replace AM/PM with Arabic equivalents (case-insensitive)
  result = result.replaceAll(RegExp(r'AM', caseSensitive: false), 'ص');
  result = result.replaceAll(RegExp(r'PM', caseSensitive: false), 'م');

  // Replace digits
  for (int i = 0; i < englishDigits.length; i++) {
    result = result.replaceAll(englishDigits[i], arabicDigits[i]);
  }

  return result;
}

/// Returns (isStep1Active, isStep2Active, isStep3Active)
(bool, bool, bool) getOrderStepStatus(String orderStatusEn) {
  final status = orderStatusEn.toLowerCase();

  switch (status) {
    case 'new':
      return (true, false, false);

    case 'preparing':
      return (true, true, false);

    case 'on the way':
    case 'pickup':
    case 'ready for pickup':
      return (true, true, true);

    default:
      return (false, false, false);
  }
}
