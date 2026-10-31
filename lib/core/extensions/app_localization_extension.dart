import 'package:flutter/material.dart';
import 'package:date_app/l10n/api_translator.dart';

extension LocalizationExtension on BuildContext {
  String apitr(String key) {
    final langCode = Localizations.localeOf(this).languageCode;

    return ApiTranslator.translate(key, langCode);
  }
}
