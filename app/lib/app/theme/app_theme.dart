import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';

abstract final class AppTheme {
  static final light = _build(_lightScheme);
  static final dark = _build(_darkScheme);

  static const _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.olive,
    onPrimary: Colors.white,
    primaryContainer: AppColors.oliveLight,
    onPrimaryContainer: AppColors.oliveDark,
    secondary: AppColors.bronze,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.bronzeLight,
    onSecondaryContainer: Color(0xFF34230F),
    tertiary: AppColors.success,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFD2E8D6),
    onTertiaryContainer: Color(0xFF0D2816),
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: AppColors.marble,
    onSurface: AppColors.ink,
    onSurfaceVariant: AppColors.slate,
    outline: Color(0xFF747A75),
    outlineVariant: AppColors.limestone,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.ink,
    onInverseSurface: AppColors.marble,
    inversePrimary: Color(0xFFB2CCB8),
  );

  static const _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFB2CCB8),
    onPrimary: AppColors.oliveDark,
    primaryContainer: Color(0xFF354B3D),
    onPrimaryContainer: Color(0xFFD0E8D5),
    secondary: Color(0xFFD8BA92),
    onSecondary: Color(0xFF402D14),
    secondaryContainer: Color(0xFF584326),
    onSecondaryContainer: AppColors.bronzeLight,
    tertiary: Color(0xFFB6CCBA),
    onTertiary: Color(0xFF213526),
    tertiaryContainer: Color(0xFF374B3B),
    onTertiaryContainer: Color(0xFFD2E8D6),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: AppColors.night,
    onSurface: Color(0xFFE2E7E2),
    onSurfaceVariant: Color(0xFFC1C8C1),
    outline: Color(0xFF8B938C),
    outlineVariant: Color(0xFF3F4741),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFE2E7E2),
    onInverseSurface: Color(0xFF2A302B),
    inversePrimary: AppColors.olive,
  );

  static ThemeData _build(ColorScheme colors) {
    final textTheme = _textTheme(colors);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: colors.outlineVariant),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surfaceContainer,
        elevation: 0,
        indicatorColor: colors.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.primaryContainer,
        selectedIconTheme: IconThemeData(color: colors.onPrimaryContainer),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colors.onSurface,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.control),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.control),
          side: BorderSide(color: colors.outline),
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerLow,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.control,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.control,
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.control,
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.primaryContainer,
        circularTrackColor: colors.primaryContainer,
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme colors) {
    const base = TextTheme(
      displayLarge: TextStyle(fontSize: 57, height: 1.12, letterSpacing: -0.25),
      displayMedium: TextStyle(fontSize: 45, height: 1.16),
      displaySmall: TextStyle(fontSize: 36, height: 1.22),
      headlineLarge: TextStyle(fontSize: 32, height: 1.25),
      headlineMedium: TextStyle(fontSize: 28, height: 1.29),
      headlineSmall: TextStyle(fontSize: 24, height: 1.33),
      titleLarge: TextStyle(fontSize: 22, height: 1.27),
      titleMedium: TextStyle(fontSize: 16, height: 1.5, letterSpacing: 0.15),
      titleSmall: TextStyle(fontSize: 14, height: 1.43, letterSpacing: 0.1),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5, letterSpacing: 0.15),
      bodyMedium: TextStyle(fontSize: 14, height: 1.43, letterSpacing: 0.25),
      bodySmall: TextStyle(fontSize: 12, height: 1.33, letterSpacing: 0.4),
      labelLarge: TextStyle(fontSize: 14, height: 1.43, letterSpacing: 0.1),
      labelMedium: TextStyle(fontSize: 12, height: 1.33, letterSpacing: 0.5),
      labelSmall: TextStyle(fontSize: 11, height: 1.45, letterSpacing: 0.5),
    );

    final colored = base.apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
    );

    return colored.copyWith(
      displayLarge: colored.displayLarge?.copyWith(fontWeight: FontWeight.w600),
      displayMedium: colored.displayMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      displaySmall: colored.displaySmall?.copyWith(fontWeight: FontWeight.w600),
      headlineLarge: colored.headlineLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: colored.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: colored.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleLarge: colored.titleLarge?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: colored.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: colored.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      labelLarge: colored.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
