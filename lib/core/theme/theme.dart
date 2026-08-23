import 'package:flutter/material.dart';

/// App-specific semantic status colors that fall outside Material's standard
/// [ColorScheme] roles. Chips and badges use these to convey open/closed,
/// success/neutral states with guaranteed contrast in both themes.
@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.success,
    required this.onSuccess,
    required this.neutral,
    required this.onNeutral,
  });

  final Color success;
  final Color onSuccess;
  final Color neutral;
  final Color onNeutral;

  @override
  AppStatusColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? neutral,
    Color? onNeutral,
  }) {
    return AppStatusColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      neutral: neutral ?? this.neutral,
      onNeutral: onNeutral ?? this.onNeutral,
    );
  }

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      onNeutral: Color.lerp(onNeutral, other.onNeutral, t)!,
    );
  }
}

/// Light theme — brown seed palette over a neutral grey scaffold.
/// Every text/background pair meets WCAG AA (>= 4.5:1).
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF795548),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD7CCC8),
    onPrimaryContainer: Color(0xFF3E2723),
    secondary: Color(0xFF6D4C41),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFBCAAA4),
    onSecondaryContainer: Color(0xFF3E2723),
    error: Color(0xFFB71C1C),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFCDD2),
    onErrorContainer: Color(0xFF8B0000),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF212121),
    surfaceContainerHighest: Color(0xFFE7E0E0),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
  ),
  scaffoldBackgroundColor: const Color(0xFFE0E0E0),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF424242),
    foregroundColor: Color(0xFFFFFFFF),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Color(0xFF212121)),
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Color(0xFF795548)),
    ),
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFFEFEBE9),
  ),
  extensions: const [
    AppStatusColors(
      success: Color(0xFF2E7D32),
      onSuccess: Color(0xFFFFFFFF),
      neutral: Color(0xFF616161),
      onNeutral: Color(0xFFFFFFFF),
    ),
  ],
);

/// Dark theme — same brown seed, inverted luminance. Text/background pairs
/// meet WCAG AA (>= 4.5:1).
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFBCAAA4),
    onPrimary: Color(0xFF3E2723),
    primaryContainer: Color(0xFF5D4037),
    onPrimaryContainer: Color(0xFFD7CCC8),
    secondary: Color(0xFFA1887F),
    onSecondary: Color(0xFF3E2723),
    secondaryContainer: Color(0xFF4E342E),
    onSecondaryContainer: Color(0xFFBCAAA4),
    error: Color(0xFFEF9A9A),
    onError: Color(0xFF3E2723),
    errorContainer: Color(0xFF8B0000),
    onErrorContainer: Color(0xFFFFCDD2),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE0E0E0),
    surfaceContainerHighest: Color(0xFF2C2C2C),
    onSurfaceVariant: Color(0xFFCAC4D0),
    outline: Color(0xFF938F99),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF212121),
    foregroundColor: Color(0xFFFFFFFF),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Color(0xFFE0E0E0)),
    ),
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(Color(0xFFBCAAA4)),
    ),
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xFF3E2723),
  ),
  extensions: const [
    AppStatusColors(
      success: Color(0xFF1B5E20),
      onSuccess: Color(0xFFFFFFFF),
      neutral: Color(0xFF424242),
      onNeutral: Color(0xFFFFFFFF),
    ),
  ],
);
