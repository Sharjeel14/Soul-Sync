import 'package:flutter/widgets.dart';
import 'package:date_app/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  /// Shortcut to access localization strings
  AppLocalizations get tr => AppLocalizations.of(this)!;
}
