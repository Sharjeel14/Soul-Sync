import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/utils/responsiveness.dart';
import 'package:date_app/features/global/bloc/global_cubit.dart';
import 'package:date_app/l10n/app_localizations.dart';

import '../../core/theme/app_theme.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

/// The main application widget.
///
/// This widget wraps the app with [ScreenUtilInit] for
/// responsive design and [MaterialApp.router] for navigation.
///
/// It also sets up:
/// - App theme
/// - Localization
/// - Router configuration
class MyDatingApp extends StatelessWidget {
  const MyDatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      /// Design size of the app for scaling UI elements
      /// relative to different screen sizes.
      designSize: const Size(375, 812), // iPhone X/11/12/13/Pro width/height
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        return BlocBuilder<GlobalCubit, GlobalState>(
          builder: (context, state) {
            Responsive.init(context);
            return MaterialApp.router(
              /// Application title
              title: 'Dating App',

              /// Hide debug banner
              debugShowCheckedModeBanner: false,

              /// App theme
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: state.themeMode,

              /// Router configuration from GlobalCubit
              routerConfig: context.read<GlobalCubit>().router,

              /// Supported locales for the app
              supportedLocales: AppLocalizations.supportedLocales,

              /// Localization delegates for Material, Widgets, Cupertino
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              /// Default locale
              locale: state.locale,
            );
          },
        );
      },
    );
  }
}
