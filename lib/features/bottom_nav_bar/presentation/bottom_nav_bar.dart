import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/services/flutter_toast_service.dart';
import 'package:date_app/core/widgets/animated_loader.dart';
import 'package:date_app/core/services/presence_service.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';

import '../bloc/bottom_nav_cubit.dart';
import 'widgets/bottom_nav_widget.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();

    context.read<BottomNavCubit>().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;

          ToastService.showPrimary(context.tr.pressBackAgainToExit);
          return;
        }

        // Second press within 2 seconds → exit the app
        await PresenceService().setOffline();
        SystemNavigator.pop();
      },
      child: AppSystemOverlay(
        child: Scaffold(
          backgroundColor: context.appBackground,
          body: BlocSelector<BottomNavCubit, BottomNavState, bool>(
            selector: (state) => state.isLoading,

            builder: (context, isLoading) {
              if (isLoading) {
                return Center(child: const BreathingOpacityLoader());
              }
              return Stack(
                children: [
                  BlocSelector<
                    BottomNavCubit,
                    BottomNavState,
                    ({int currentIndex, List<Widget?> pages})
                  >(
                    selector: (state) =>
                        (currentIndex: state.currentIndex, pages: state.pages),
                    builder: (context, data) {
                      return IndexedStack(
                        index: data.currentIndex,
                        children: List.generate(
                          data.pages.length,
                          (i) =>
                              data.pages[i] ??
                              const Center(child: BreathingOpacityLoader()),
                        ),
                      );
                    },
                  ),

                  KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                      if (isKeyboardVisible) {
                        return const SizedBox.shrink();
                      }

                      return Positioned(
                        left: 24.w,
                        right: 24.w,
                        bottom: 10.h,
                        child:
                            BlocSelector<BottomNavCubit, BottomNavState, int>(
                              selector: (state) => state.currentIndex,
                              builder: (context, currentIndex) {
                                return BottomNavBarWidget(
                                  currentIndex: currentIndex,
                                );
                              },
                            ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
