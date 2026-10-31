import 'package:flutter/widgets.dart';
import 'package:date_app/core/constants/app_constants.dart';

extension LanguageExtensions on BuildContext {
  /// Returns true if the current directionality is Right-to-Left (RTL)
  bool get isArabic =>
      Localizations.localeOf(this) == const Locale(AppLanguages.arabic);

  /// Returns true if the current directionality is Left-to-Right (LTR)
  bool get isEnglish =>
      Localizations.localeOf(this) == const Locale(AppLanguages.english);

  String get languageCode => Localizations.localeOf(this).languageCode;
}
