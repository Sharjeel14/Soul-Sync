import 'package:flutter/material.dart';
import 'package:date_app/core/widgets/app_text.dart';

/// A bold section heading used across challenge, subscription and wallet pages.
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => AppText(
    text,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );
}
