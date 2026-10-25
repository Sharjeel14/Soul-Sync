import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/widgets/app_text.dart';

class ChatDatePill extends StatelessWidget {
  final DateTime date;

  const ChatDatePill({super.key, required this.date});

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(BuildContext context) {
    final now = DateTime.now();
    final localDate = date.toLocal();

    if (isSameDay(localDate, now)) {
      return context.tr.today;
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (isSameDay(localDate, yesterday)) {
      return context.tr.yesterday;
    }

    final locale = Localizations.localeOf(context).toString();
    if (localDate.year == now.year) {
      return DateFormat.MMMMd(locale).format(localDate);
    }
    return DateFormat.yMMMMd(locale).format(localDate);
  }

  @override
  Widget build(BuildContext context) {
    final label = _formatDate(context);

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: context.stroke.withValues(alpha: 0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AppText(
          label,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: context.textSecondary,
        ),
      ),
    );
  }
}
