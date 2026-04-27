import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  static const Color kBg = Color(0xFF0D0D0D);
  static const Color kCard = Color(0xFF1A1A1A);
  static const Color kGreen = Color(0xFF4CAF50);
  static const Color kGreenDim = Color(0xFF1A3D33);
  static const Color kTextPrimary = Color(0xFFFFFFFF);
  static const Color kTextSecondary = Color(0xFF8A8A8A);
  static const Color kDivider = Color(0xFF2A2A2A);

  static const Color kGreenLight = Color(0xFF81C784);
  static const Color kGreenDark = Color(0xFF388E3C);
  static const Color kCardElevated = Color(0xFF222222);
  static const Color kTextHint = Color(0xFF555555);
  static const Color kDanger = Color(0xFFD50000);
  static const Color kDangerSoft = Color(0xFF5C1B1B);
  static const Color kWhite = Color(0xFFFFFFFF);
  static const Color kBlack = Color(0xFF000000);

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: kGreen,
      onPrimary: kBlack,
      primaryContainer: kGreenDim,
      onPrimaryContainer: kGreenLight,
      secondary: kGreenLight,
      onSecondary: kBlack,
      secondaryContainer: kGreenDim,
      onSecondaryContainer: kGreenLight,
      tertiary: kGreenDark,
      onTertiary: kWhite,
      tertiaryContainer: kGreenDim,
      onTertiaryContainer: kGreenLight,
      error: kDanger,
      onError: kWhite,
      errorContainer: kDangerSoft,
      onErrorContainer: Color(0xFFFFB4AB),
      surface: kCard,
      onSurface: kTextPrimary,
      surfaceContainerHighest: kCardElevated,
      onSurfaceVariant: kTextSecondary,
      outline: kDivider,
      outlineVariant: Color(0xFF1F1F1F),
      shadow: kBlack,
      scrim: kBlack,
      inverseSurface: kWhite,
      onInverseSurface: kBlack,
      inversePrimary: kGreenDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: kBg,
      canvasColor: kBg,
      dividerColor: kDivider,
      appBarTheme: const AppBarTheme(
        backgroundColor: kBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(color: kTextPrimary),
        titleTextStyle: TextStyle(
          color: kTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: kGreen,
      onPrimary: kWhite,
      primaryContainer: kGreenLight,
      onPrimaryContainer: kGreenDark,
      secondary: kGreenLight,
      onSecondary: kBlack,
      secondaryContainer: kGreenLight,
      onSecondaryContainer: kGreenDark,
      tertiary: kGreenDark,
      onTertiary: kWhite,
      tertiaryContainer: kGreenLight,
      onTertiaryContainer: kGreenDark,
      error: kDanger,
      onError: kWhite,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: kDanger,
      surface: kWhite,
      onSurface: kBlack,
      surfaceContainerHighest: Color(0xFFF5F5F5),
      onSurfaceVariant: Color(0xFF666666),
      outline: Color(0xFFE0E0E0),
      outlineVariant: Color(0xFFEEEEEE),
      shadow: kBlack,
      scrim: kBlack,
      inverseSurface: kBg,
      onInverseSurface: kWhite,
      inversePrimary: kGreenDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: kWhite,
      canvasColor: kWhite,
    );
  }
}
