import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:date_app/core/di/injection_container.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_system_overlay.dart';
import 'package:date_app/core/router/routes.dart';

import '../bloc/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(
      begin: 0.25,
      end: 0.65,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;
    final titleColors = isDark
        ? const [Colors.white, AppColors.primaryLight]
        : const [AppColors.textPrimaryLight, AppColors.primary];
    final taglineColor = isDark
        ? AppColors.textSecondaryDark.withValues(alpha: 0.8)
        : AppColors.textSecondaryLight;
    final progressBgColor = isDark ? AppColors.surfaceCard : AppColors.grey300;

    return BlocProvider(
      create: (_) => getIt<SplashCubit>(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state.isLoading) return;
          if (state.isLoggedIn) {
            context.go(AppRoutes.bottomNavBar);
          } else if (state.isOnboardingCompleted) {
            context.go(AppRoutes.login);
          } else {
            context.go(AppRoutes.onboarding);
          }
        },
        child: AppSystemOverlay(
          child: Scaffold(
            backgroundColor: backgroundColor,
            body: Stack(
              children: [
                // Ambient background glows
                Positioned(
                  top: -60,
                  left: -60,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : AppColors.primaryLight.withValues(alpha: 0.18),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  right: -80,
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.primaryGradientEnd.withValues(alpha: 0.10)
                          : AppColors.primary.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ── Glowing Dating Logo ──
                          Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primaryGradientEnd,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: isDark
                                          ? _glowAnimation.value
                                          : _glowAnimation.value * 0.5,
                                    ),
                                    blurRadius: isDark ? 36 : 28,
                                    spreadRadius: isDark ? 6 : 4,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.white,
                                  size: 52,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // ── App Name ──
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                LinearGradient(colors: titleColors)
                                    .createShader(bounds),
                            child: Text(
                              'SoulSync',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : AppColors.textPrimaryLight,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // ── Tagline ──
                          Text(
                            'Find Your Genuine Connection',
                            style: TextStyle(
                              color: taglineColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 48),

                          // ── Smooth pulsing indicator ──
                          SizedBox(
                            width: 44,
                            height: 4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                backgroundColor: progressBgColor,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary.withValues(
                                    alpha: isDark ? 0.7 : 0.85,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
