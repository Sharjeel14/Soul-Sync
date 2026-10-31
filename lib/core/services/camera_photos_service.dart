// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPhotosService {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isDenied) {
      return false;
    }

    if (status.isPermanentlyDenied) {
      return false;
    }

    return status.isGranted;
  }

  static Future<bool> requestPhotosPermission(BuildContext context) async {
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
      return true;
    }

    if (status.isDenied) {
      return false;
    }

    if (status.isPermanentlyDenied) {
      return false;
    }

    return status.isGranted;
  }
}
