import 'package:flutter/material.dart';

// ============================================================
// RESPONSIVENESS CLASS - Full Configuration & Layout System
// ============================================================

/// Breakpoints used across the app.
/// Customize these to match your design system.
class AppBreakpoints {
  static const double mobileSmall = 320;
  static const double mobile = 480;
  static const double tablet = 768;
  static const double tabletLarge = 1024;
  static const double desktop = 1280;
  static const double desktopLarge = 1440;
  static const double desktopXL = 1920;
}

/// Represents the current screen size category.
enum ScreenSize {
  mobileSmall,
  mobile,
  tablet,
  tabletLarge,
  desktop,
  desktopLarge,
  desktopXL,
}

/// Orientation of the device.
enum DeviceOrientation { portrait, landscape }

/// Primary Responsive helper class.
/// Use [Responsive.of(context)] to access all responsive utilities.
class Responsive {
  Responsive._();

  static late MediaQueryData _mediaQuery;

  /// Initialize once (usually in MaterialApp builder)
  static void init(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
  }

  // ─── Raw Dimensions ───────────────────────────────────────

  static double get screenWidth => _mediaQuery.size.width;
  static double get screenHeight => _mediaQuery.size.height;
  static double get pixelRatio => _mediaQuery.devicePixelRatio;
  static double get textScaleFactor => _mediaQuery.textScaler.scale(1.0);
  static EdgeInsets get padding => _mediaQuery.padding;
  static EdgeInsets get viewInsets => _mediaQuery.viewInsets;
  static EdgeInsets get viewPadding => _mediaQuery.viewPadding;

  // ─── Screen Size Category ─────────────────────────────────

  static ScreenSize get screenSize {
    final w = screenWidth;
    if (w < AppBreakpoints.mobileSmall) return ScreenSize.mobileSmall;
    if (w < AppBreakpoints.mobile) return ScreenSize.mobile;
    if (w < AppBreakpoints.tablet) return ScreenSize.tablet;
    if (w < AppBreakpoints.tabletLarge) return ScreenSize.tabletLarge;
    if (w < AppBreakpoints.desktop) return ScreenSize.desktop;
    if (w < AppBreakpoints.desktopLarge) return ScreenSize.desktopLarge;
    return ScreenSize.desktopXL;
  }

  // ─── Boolean Helpers ──────────────────────────────────────

  static bool get isMobileSmall => screenSize == ScreenSize.mobileSmall;

  static bool get isMobile =>
      screenSize == ScreenSize.mobileSmall || screenSize == ScreenSize.mobile;

  static bool get isTablet =>
      screenSize == ScreenSize.tablet || screenSize == ScreenSize.tabletLarge;

  static bool get isDesktop =>
      screenSize == ScreenSize.desktop ||
      screenSize == ScreenSize.desktopLarge ||
      screenSize == ScreenSize.desktopXL;

  static bool get isMobileOrTablet => isMobile || isTablet;
  static bool get isTabletOrDesktop => isTablet || isDesktop;

  static DeviceOrientation get orientation => screenWidth > screenHeight
      ? DeviceOrientation.landscape
      : DeviceOrientation.portrait;

  static bool get isPortrait => orientation == DeviceOrientation.portrait;
  static bool get isLandscape => orientation == DeviceOrientation.landscape;

  // ─── Fluid Sizing ─────────────────────────────────────────

  static double wp(double percent) => screenWidth * percent / 100;

  static double hp(double percent) => screenHeight * percent / 100;

  static double sp(double size, {double baseWidth = 375}) =>
      size * screenWidth / baseWidth;

  static double clampedSp(
    double size, {
    double min = 0,
    double max = double.infinity,
  }) => sp(size).clamp(min, max);

  // ─── Responsive Value Selector ────────────────────────────

  static T value<T>({
    required T mobile,
    T? mobileSmall,
    T? tablet,
    T? tabletLarge,
    T? desktop,
    T? desktopLarge,
    T? desktopXL,
  }) {
    switch (screenSize) {
      case ScreenSize.mobileSmall:
        return mobileSmall ?? mobile;

      case ScreenSize.mobile:
        return mobile;

      case ScreenSize.tablet:
        return tablet ?? mobile;

      case ScreenSize.tabletLarge:
        return tabletLarge ?? tablet ?? mobile;

      case ScreenSize.desktop:
        return desktop ?? tabletLarge ?? tablet ?? mobile;

      case ScreenSize.desktopLarge:
        return desktopLarge ?? desktop ?? tabletLarge ?? tablet ?? mobile;

      case ScreenSize.desktopXL:
        return desktopXL ??
            desktopLarge ??
            desktop ??
            tabletLarge ??
            tablet ??
            mobile;
    }
  }

  // ─── Grid System ──────────────────────────────────────────

  static int get columns => value<int>(
    mobileSmall: 1,
    mobile: 2,
    tablet: 3,
    tabletLarge: 4,
    desktop: 6,
    desktopLarge: 8,
    desktopXL: 12,
  );

  static double get horizontalPadding => value<double>(
    mobileSmall: 12,
    mobile: 16,
    tablet: 24,
    tabletLarge: 32,
    desktop: 48,
    desktopLarge: 64,
    desktopXL: 80,
  );

  static double get gridSpacing =>
      value<double>(mobile: 12, tablet: 16, desktop: 24);

  // ─── Typography Scale ─────────────────────────────────────

  static double get displayLarge =>
      value<double>(mobile: 36, tablet: 48, desktop: 64);

  static double get displayMedium =>
      value<double>(mobile: 28, tablet: 36, desktop: 48);

  static double get headlineLarge =>
      value<double>(mobile: 24, tablet: 30, desktop: 36);

  static double get headlineMedium =>
      value<double>(mobile: 20, tablet: 24, desktop: 28);

  static double get titleLarge =>
      value<double>(mobile: 18, tablet: 20, desktop: 22);

  static double get titleMedium =>
      value<double>(mobile: 16, tablet: 18, desktop: 20);

  static double get bodyLarge =>
      value<double>(mobile: 16, tablet: 16, desktop: 18);

  static double get bodyMedium =>
      value<double>(mobile: 14, tablet: 15, desktop: 16);

  static double get bodySmall =>
      value<double>(mobile: 12, tablet: 13, desktop: 14);

  static double get labelSmall =>
      value<double>(mobile: 11, tablet: 11, desktop: 12);

  // ─── Icon Sizes ───────────────────────────────────────────

  static double get iconSmall =>
      value<double>(mobile: 16, tablet: 18, desktop: 20);

  static double get iconMedium =>
      value<double>(mobile: 24, tablet: 26, desktop: 28);

  static double get iconLarge =>
      value<double>(mobile: 32, tablet: 36, desktop: 40);

  // ─── Spacing Scale ────────────────────────────────────────

  static double get xs => value<double>(mobile: 4, tablet: 6, desktop: 8);
  static double get sm => value<double>(mobile: 8, tablet: 10, desktop: 12);
  static double get md => value<double>(mobile: 16, tablet: 20, desktop: 24);
  static double get lg => value<double>(mobile: 24, tablet: 32, desktop: 40);
  static double get xl => value<double>(mobile: 32, tablet: 48, desktop: 64);
  static double get xxl => value<double>(mobile: 48, tablet: 64, desktop: 96);

  // ─── Border Radius ────────────────────────────────────────

  static double get radiusSm => value<double>(mobile: 6, tablet: 8, desktop: 8);

  static double get radiusMd =>
      value<double>(mobile: 10, tablet: 12, desktop: 14);

  static double get radiusLg =>
      value<double>(mobile: 16, tablet: 20, desktop: 24);

  static double get radiusXl =>
      value<double>(mobile: 24, tablet: 28, desktop: 32);

  // ─── Max Content Width ────────────────────────────────────

  static double get maxContentWidth => value<double>(
    mobile: double.infinity,
    tablet: 720,
    desktop: 1200,
    desktopXL: 1400,
  );
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop && desktop != null) {
      return desktop!(context);
    }

    if (Responsive.isTablet && tablet != null) {
      return tablet!(context);
    }

    return mobile(context);
  }
}
