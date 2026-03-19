import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ─── Saba Heritage Color Tokens ──────────────────────────────────────────────
abstract class SabaColors {
  // Primary — Burgundy
  static const Color primary = Color(0xFF570013);
  static const Color primaryContainer = Color(0xFF800020);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFF828A);

  // Secondary — Muted Gold
  static const Color secondary = Color(0xFF775A19);
  static const Color secondaryContainer = Color(0xFFFED488);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF785A1A);

  // Tertiary — Soft Charcoal
  static const Color tertiary = Color(0xFF272727);
  static const Color tertiaryContainer = Color(0xFF3D3D3D);
  static const Color onTertiary = Color(0xFFFFFFFF);

  // Surface hierarchy (premium vellum stack)
  static const Color surface = Color(0xFFFCF9F8);
  static const Color surfaceDim = Color(0xFFDCD9D9);
  static const Color surfaceBright = Color(0xFFFCF9F8);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3F2);
  static const Color surfaceContainer = Color(0xFFF0EDEC);
  static const Color surfaceContainerHigh = Color(0xFFEBE7E7);
  static const Color surfaceContainerHighest = Color(0xFFE5E2E1);
  static const Color surfaceVariant = Color(0xFFE5E2E1);

  // On-surface
  static const Color onBackground = Color(0xFF1C1B1B);
  static const Color onSurface = Color(0xFF1C1B1B);
  static const Color onSurfaceVariant = Color(0xFF584141);

  // Outline
  static const Color outline = Color(0xFF8C7071);
  static const Color outlineVariant = Color(0xFFE0BFBF);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
}

/// ─── Saba Heritage Typography ────────────────────────────────────────────────
abstract class SabaTypography {
  /// Noto Serif Ethiopic — for display and headlines (book titles, chapter headers)
  static TextStyle displayLarge() => GoogleFonts.notoSerifEthiopic(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
        color: SabaColors.onBackground,
      );

  static TextStyle displayMedium() => GoogleFonts.notoSerifEthiopic(
        fontSize: 44,
        fontWeight: FontWeight.w400,
        height: 1.16,
        color: SabaColors.onBackground,
      );

  static TextStyle displaySmall() => GoogleFonts.notoSerifEthiopic(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 1.22,
        color: SabaColors.onBackground,
      );

  static TextStyle headlineLarge() => GoogleFonts.notoSerifEthiopic(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: SabaColors.onBackground,
      );

  static TextStyle headlineMedium() => GoogleFonts.notoSerifEthiopic(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        height: 1.29,
        color: SabaColors.onBackground,
      );

  static TextStyle headlineSmall() => GoogleFonts.notoSerifEthiopic(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.33,
        color: SabaColors.onBackground,
      );

  /// Inter — for body text and labels (high legibility, line-height 1.6×)
  static TextStyle bodyLarge() => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: SabaColors.onBackground,
      );

  static TextStyle bodyMedium() => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: SabaColors.onBackground,
      );

  static TextStyle bodySmall() => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: SabaColors.onSurfaceVariant,
      );

  static TextStyle labelLarge() => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: SabaColors.onBackground,
      );

  static TextStyle labelMedium() => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: SabaColors.onBackground,
      );

  static TextStyle labelSmall() => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: SabaColors.onSurfaceVariant,
      );
}

/// ─── Saba Heritage Theme ─────────────────────────────────────────────────────
abstract class SabaTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: SabaColors.primary,
      onPrimary: SabaColors.onPrimary,
      primaryContainer: SabaColors.primaryContainer,
      onPrimaryContainer: SabaColors.onPrimaryContainer,
      secondary: SabaColors.secondary,
      onSecondary: SabaColors.onSecondary,
      secondaryContainer: SabaColors.secondaryContainer,
      onSecondaryContainer: SabaColors.onSecondaryContainer,
      tertiary: SabaColors.tertiary,
      onTertiary: SabaColors.onTertiary,
      tertiaryContainer: SabaColors.tertiaryContainer,
      onTertiaryContainer: SabaColors.onTertiary,
      error: SabaColors.error,
      onError: SabaColors.onError,
      errorContainer: SabaColors.errorContainer,
      onErrorContainer: SabaColors.error,
      surface: SabaColors.surface,
      onSurface: SabaColors.onSurface,
      onSurfaceVariant: SabaColors.onSurfaceVariant,
      outline: SabaColors.outline,
      outlineVariant: SabaColors.outlineVariant,
      surfaceContainerHighest: SabaColors.surfaceContainerHighest,
      surfaceContainerHigh: SabaColors.surfaceContainerHigh,
      surfaceContainer: SabaColors.surfaceContainer,
      surfaceContainerLow: SabaColors.surfaceContainerLow,
      surfaceContainerLowest: SabaColors.surfaceContainerLowest,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: SabaColors.surface,
      // ── Typography ──────────────────────────────────────────
      textTheme: TextTheme(
        displayLarge: SabaTypography.displayLarge(),
        displayMedium: SabaTypography.displayMedium(),
        displaySmall: SabaTypography.displaySmall(),
        headlineLarge: SabaTypography.headlineLarge(),
        headlineMedium: SabaTypography.headlineMedium(),
        headlineSmall: SabaTypography.headlineSmall(),
        bodyLarge: SabaTypography.bodyLarge(),
        bodyMedium: SabaTypography.bodyMedium(),
        bodySmall: SabaTypography.bodySmall(),
        labelLarge: SabaTypography.labelLarge(),
        labelMedium: SabaTypography.labelMedium(),
        labelSmall: SabaTypography.labelSmall(),
      ),
      // ── No dividers rule ────────────────────────────────────
      dividerTheme: const DividerThemeData(color: Colors.transparent, space: 0),
      // ── Pill-shaped primary buttons (gradient applied at widget level) ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SabaColors.primary,
          foregroundColor: SabaColors.onPrimary,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: SabaTypography.labelLarge(),
          elevation: 0,
        ),
      ),
      // ── Ghost-border inputs ─────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SabaColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: SabaColors.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: SabaColors.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: SabaColors.primary.withValues(alpha: 0.5)),
        ),
        hintStyle: SabaTypography.bodyMedium()
            .copyWith(color: SabaColors.onSurfaceVariant),
      ),
      // ── NavigationBar ───────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: SabaColors.surfaceContainerLowest,
        indicatorColor: SabaColors.secondaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: SabaColors.onSecondaryContainer,
              size: 22,
            );
          }
          return const IconThemeData(
            color: SabaColors.onSurfaceVariant,
            size: 22,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SabaTypography.labelSmall()
                .copyWith(color: SabaColors.onSecondaryContainer);
          }
          return SabaTypography.labelSmall();
        }),
      ),
      // ── AppBar (base, glassmorphism applied at widget level) ─
      appBarTheme: AppBarTheme(
        backgroundColor: SabaColors.surface.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: SabaTypography.headlineSmall(),
        iconTheme: const IconThemeData(color: SabaColors.onSurface),
      ),
      // ── Chip ───────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: SabaColors.surfaceContainerLowest,
        selectedColor: SabaColors.secondaryContainer,
        labelStyle: SabaTypography.labelMedium(),
        side: BorderSide(color: SabaColors.outlineVariant.withValues(alpha: 0.15)),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }
}
