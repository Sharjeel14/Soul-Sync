import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_app/core/constants/app_constants.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:date_app/features/global/bloc/global_cubit.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isLTR;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () =>
              context.read<GlobalCubit>().updateLocale(AppLanguages.english),
          behavior: HitTestBehavior.opaque,
          child: AppText(
            context.tr.eng,
            fontWeight: isArabic ? FontWeight.w700 : FontWeight.bold,
            color: AppColors.white,
            fontSize: isArabic ? 16 : 14,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AppText('|'),
        ),
        GestureDetector(
          onTap: () =>
              context.read<GlobalCubit>().updateLocale(AppLanguages.arabic),
          behavior: HitTestBehavior.opaque,
          child: AppText(
            context.tr.arabic,
            fontWeight: isArabic ? FontWeight.w700 : FontWeight.bold,
            fontSize: isArabic ? 14 : 16,
            color: AppColors.white,
            fontFamily: AppFontFamily.notoSansArabic,
          ),
        ),
      ],
    );
  }
}
