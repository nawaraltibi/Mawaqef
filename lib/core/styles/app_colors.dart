import 'dart:ui';

/// App Colors
/// Centralized color definitions extracted from design reference
/// All colors are based on the parking app design system
class AppColors {
  // ============================================
  // PRIMARY COLORS - Extracted from design reference
  // ============================================
  /// Primary blue color - Main brand color for buttons, app bars, and active states
  /// This is the dominant blue from the design reference images
  static const Color primary = Color(
    0xFF2DC3D4,
  ); // Professional parking app blue

  /// Darker shade of primary - Used for hover states and pressed buttons
  static const Color primaryDark = Color(0xFF0052A3); // Darker blue for depth

  /// Lighter shade of primary - Used for subtle highlights and backgrounds
  static const Color primaryLight = Color(0xFF3385D6); // Lighter blue variant

  /// Accent color - Complementary color for secondary actions
  static const Color accent = Color(0xFF4DA6FF); // Light blue accent

  /// Primary with opacity variations for backgrounds and overlays
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);

  // ============================================
  // GRADIENT COLORS - For onboarding and special backgrounds
  // ============================================
  /// Gradient start color - Primary brand color at top
  /// Creates a vibrant teal/cyan gradient backdrop
  static const Color gradientStart = Color(
    0xFF2DC3D4,
  ); // Primary teal (#2DC3D4)

  /// Gradient middle color - Lighter blend of primary
  /// Creates smooth transition to lighter tones
  static const Color gradientMiddle = Color(0xFF4DD0E1); // Light cyan blend

  /// Gradient end color - Soft white/light blend for airy feel
  /// Blends from teal to white for modern, airy gradient
  static const Color gradientEnd = Color(
    0xFFE0F7FA,
  ); // Very light teal/white blend

  /// Onboarding gradient - Pre-configured gradient colors list
  /// Flows from vibrant #2dc3d4 at top to soft white at bottom
  static const List<Color> onboardingGradient = [
    gradientStart, // Top: Primary teal (#2DC3D4)
    gradientMiddle, // Middle: Light cyan blend
    gradientEnd, // Bottom: Soft white/light teal
  ];

  // ============================================
  // BUTTON GRADIENT COLORS - For elegant button styling
  // ============================================
  /// Button gradient start color - Lighter shade of #2dc3d4
  /// Creates a vibrant, modern gradient on buttons
  static const Color buttonGradientStart = Color(
    0xFF4DD0E1,
  ); // Light cyan (#4DD0E1)

  /// Button gradient end color - Darker cyan/turquoise for gradient
  /// Slightly darker than primary for visual depth
  static const Color buttonGradientEnd = Color(
    0xFF26B8C9,
  ); // Darker cyan (#26B8C9)

  /// Button gradient - Pre-configured gradient for buttons
  /// Smooth gradient from light cyan to darker cyan/turquoise
  /// Creates a modern, high-end look that matches the design reference
  static const List<Color> buttonGradient = [
    buttonGradientStart, // Start: Light cyan (#4DD0E1)
    buttonGradientEnd, // End: Darker cyan (#26B8C9)
  ];

  // Grey Colors
  static const Color logoGrey = Color(0xFFEAEAEA);
  static const Color profileGrey = Color(0xFFF0EFF0);
  static const Color tabGrey = Color(0xFFEEEEEE);
  static const Color selectedMenuItemGrey = Color(0xFFF4F5FB);
  static const Color textFieldGrey = Color(0xFFD0D5DD);
  static const Color profileBackGrey = Color(0xFFF4F7FA);
  static const Color restorePasswordGrey = Color(0xFF808080);
  static const Color textGrey = Color(0xFF667085);
  static const Color userGrey = Color(0xFF606060);
  static const Color sideMenuGrey = Color(0xFF666666);
  static const Color sideMenuItemGrey = Color(0xFF424242);

  // ============================================
  // BLUE TONES - Supporting primary color palette
  // ============================================
  /// Light blue background - Used for subtle primary-colored backgrounds
  static const Color lightBlue = Color(
    0xFFE6F2FF,
  ); // Very light blue background

  /// Medium blue - Used for secondary elements and borders
  static const Color mediumBlue = Color(0xFF80BFFF); // Medium blue for accents

  /// Dark blue - Used for text on light backgrounds and emphasis
  static const Color darkBlue = Color(0xFF003D7A); // Dark blue for contrast

  // ============================================
  // STATUS & FEEDBACK COLORS
  // ============================================
  /// Error color - Used for error states and destructive actions
  static Color get error => const Color(0xFFED4242);

  /// Success color - Used for success states and positive feedback
  static const Color success = Color(0xFF10B981);

  /// Warning color - Used for warning states and caution messages
  static const Color warning = Color(0xFFF59E0B);

  /// Info color - Used for informational messages (matches primary)
  static const Color info = primary;

  // White Shades
  static const Color brightWhite = Color(0xFFFFFFFF);
  static const Color darkWhite = Color(0xFFF9FAFB);

  // ============================================
  // TEXT COLORS
  // ============================================
  /// Primary text color - Main text color for body content
  static const Color primaryText = Color(
    0xFF1A1A1A,
  ); // Near black for readability

  /// Secondary text color - Used for hints, labels, and less important text
  static const Color secondaryText = Color(0xFF667085); // Medium gray

  /// Text color on primary backgrounds - White text on blue buttons/app bars
  static const Color textOnPrimary = Color(0xFFFFFFFF); // Pure white

  /// Disabled text color - Used for disabled states
  static const Color disabledText = Color(0xFF9CA3AF); // Light gray

  // ============================================
  // BACKGROUND & SURFACE COLORS
  // ============================================
  /// Main background color - Scaffold and page backgrounds
  static const Color background = Color(0xFFFAFAFA); // Very light gray

  /// Surface color - Cards, containers, and elevated surfaces
  static const Color surface = Color(0xFFFFFFFF); // Pure white

  /// Secondary background - Used for alternate sections
  static const Color backgroundSecondary = Color(
    0xFFF5F5F5,
  ); // Slightly darker gray

  // ============================================
  // BORDER & DIVIDER COLORS
  // ============================================
  /// Primary border color - Used for input fields and containers
  static const Color border = Color(0xFFE4E7EC); // Light gray border

  /// Secondary border color - Used for subtle dividers
  static const Color secondaryBorder = Color(0xFFF2F4F7); // Very light border

  /// Focused border color - Used when inputs are focused (matches primary)
  static const Color borderFocused = primary;

  // ============================================
  // ICON COLORS
  // ============================================
  /// Default icon color - Used for most icons
  static const Color icon = Color(0xFF667085); // Medium gray

  /// Primary icon color - Used for active/selected icons
  static const Color iconPrimary = primary;

  /// Secondary icon color - Used for less important icons
  static const Color iconSecondary = Color(0xFF9CA3AF); // Light gray

  // ============================================
  // BUTTON STATE COLORS
  // ============================================
  /// Button pressed/hover state - Slightly darker than primary
  static const Color buttonPressed = primaryDark;

  /// Button disabled state - Light gray for disabled buttons
  static const Color buttonDisabled = Color(0xFFE5E7EB);

  /// Button disabled text - Gray text for disabled buttons
  static const Color buttonDisabledText = disabledText;
}
