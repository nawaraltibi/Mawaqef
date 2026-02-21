import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized dimensions and spacing constants
/// All values use flutter_screenutil for responsive sizing
/// Usage: AppDimens.paddingM.w for width-based, AppDimens.paddingM.h for height-based
class AppDimens {
  // Private constructor to prevent instantiation
  AppDimens._();

  // ============================================
  // PADDING / MARGIN VALUES
  // ============================================

  /// Extra extra small padding: 2
  static const double paddingXXS = 2;

  /// Extra small padding: 4
  static const double paddingXS = 4;

  /// Small padding: 8
  static const double paddingS = 8;

  /// Small-Medium padding: 10
  static const double paddingSM = 10;

  /// Medium padding: 12
  static const double paddingM = 12;

  /// Medium-Large padding: 14
  static const double paddingML = 14;

  /// Large padding: 16
  static const double paddingL = 16;

  /// Extra large padding: 20
  static const double paddingXL = 20;

  /// Extra extra large padding: 24
  static const double paddingXXL = 24;

  /// Triple extra large padding: 28
  static const double paddingXXXL = 28;

  /// Huge padding: 32
  static const double paddingHuge = 32;

  /// Extra huge padding: 40
  static const double paddingExtraHuge = 40;

  // ============================================
  // SPACING (SizedBox) VALUES
  // ============================================

  /// Extra small spacing: 4
  static const double spacingXS = 4;

  /// Small spacing: 6
  static const double spacingS = 6;

  /// Medium spacing: 8
  static const double spacingM = 8;

  /// Medium-Large spacing: 10
  static const double spacingML = 10;

  /// Large spacing: 12
  static const double spacingL = 12;

  /// Extra large spacing: 16
  static const double spacingXL = 16;

  /// Extra extra large spacing: 20
  static const double spacingXXL = 20;

  /// Triple extra large spacing: 24
  static const double spacingXXXL = 24;

  /// Huge spacing: 30
  static const double spacingHuge = 30;

  /// Extra huge spacing: 32
  static const double spacingExtraHuge = 32;

  /// Maximum spacing: 40
  static const double spacingMax = 40;

  // ============================================
  // BORDER RADIUS VALUES
  // ============================================

  /// Extra small radius: 2
  static const double radiusXS = 2;

  /// Small radius: 4
  static const double radiusS = 4;

  /// Small-Medium radius: 6
  static const double radiusSM = 6;

  /// Medium radius: 8
  static const double radiusM = 8;

  /// Medium-Large radius: 10
  static const double radiusML = 10;

  /// Large radius: 12
  static const double radiusL = 12;

  /// Extra large radius: 14
  static const double radiusXL = 14;

  /// Extra extra large radius: 16
  static const double radiusXXL = 16;

  /// Triple extra large radius: 18
  static const double radiusXXXL = 18;

  /// Huge radius: 20
  static const double radiusHuge = 20;

  /// Extra huge radius: 22
  static const double radiusExtraHuge = 22;

  /// Maximum radius: 24
  static const double radiusMax = 24;

  /// Circle radius: 28
  static const double radiusCircle = 28;

  /// Full circle radius: 100
  static const double radiusFullCircle = 100;

  // ============================================
  // ICON SIZES
  // ============================================

  /// Extra small icon: 12
  static const double iconXS = 12;

  /// Small icon: 14
  static const double iconS = 14;

  /// Medium icon: 16
  static const double iconM = 16;

  /// Medium-Large icon: 18
  static const double iconML = 18;

  /// Large icon: 20
  static const double iconL = 20;

  /// Extra large icon: 22
  static const double iconXL = 22;

  /// Extra extra large icon: 24
  static const double iconXXL = 24;

  /// Huge icon: 28
  static const double iconHuge = 28;

  /// Extra huge icon: 32
  static const double iconExtraHuge = 32;

  /// Maximum icon: 40
  static const double iconMax = 40;

  /// Giant icon: 48
  static const double iconGiant = 48;

  /// Hero icon: 64
  static const double iconHero = 64;

  // ============================================
  // BUTTON SIZES
  // ============================================

  /// Small button height: 36
  static const double buttonHeightS = 36;

  /// Medium button height: 44
  static const double buttonHeightM = 44;

  /// Large button height: 48
  static const double buttonHeightL = 48;

  /// Extra large button height: 52
  static const double buttonHeightXL = 52;

  /// FAB size: 56
  static const double fabSize = 56;

  /// Mini FAB size: 40
  static const double fabSizeMini = 40;

  // ============================================
  // INPUT FIELD SIZES
  // ============================================

  /// Text field height: 48
  static const double textFieldHeight = 48;

  /// Text field border width: 1
  static const double textFieldBorderWidth = 1;

  /// Text field border width focused: 2
  static const double textFieldBorderWidthFocused = 2;

  // ============================================
  // CARD / CONTAINER SIZES
  // ============================================

  /// Small card padding: 8
  static const double cardPaddingS = 8;

  /// Medium card padding: 12
  static const double cardPaddingM = 12;

  /// Large card padding: 16
  static const double cardPaddingL = 16;

  /// Card elevation: 2
  static const double cardElevation = 2;

  /// Card elevation raised: 4
  static const double cardElevationRaised = 4;

  // ============================================
  // APP BAR SIZES
  // ============================================

  /// App bar height: 56
  static const double appBarHeight = 56;

  /// App bar icon size: 24
  static const double appBarIconSize = 24;

  // ============================================
  // BOTTOM NAVIGATION
  // ============================================

  /// Bottom nav height: 60
  static const double bottomNavHeight = 60;

  /// Bottom nav icon size: 24
  static const double bottomNavIconSize = 24;

  // ============================================
  // MAP RELATED
  // ============================================

  /// Default map zoom level: 16
  static const double mapDefaultZoom = 16.0;

  /// Map min zoom level: 3
  static const double mapMinZoom = 3.0;

  /// Map max zoom level: 19
  static const double mapMaxZoom = 19.0;

  /// Map marker size: 40
  static const double mapMarkerSize = 40.0;

  // ============================================
  // MISC SIZES
  // ============================================

  /// Avatar small: 32
  static const double avatarS = 32;

  /// Avatar medium: 48
  static const double avatarM = 48;

  /// Avatar large: 64
  static const double avatarL = 64;

  /// Avatar extra large: 80
  static const double avatarXL = 80;

  /// Divider thickness: 1
  static const double dividerThickness = 1;

  /// Status indicator size: 8
  static const double statusIndicatorSize = 8;

  /// Badge size: 18
  static const double badgeSize = 18;

  // ============================================
  // RESPONSIVE HELPER METHODS
  // ============================================

  /// Get responsive width-based padding
  static double paddingW(double value) => value.w;

  /// Get responsive height-based padding
  static double paddingH(double value) => value.h;

  /// Get responsive border radius
  static double radius(double value) => value.r;

  /// Get responsive font size
  static double fontSize(double value) => value.sp;

  /// Get responsive icon size
  static double icon(double value) => value.sp;

  // ============================================
  // PRE-BUILT EDGE INSETS (using screenutil)
  // ============================================

  /// All sides padding - Small (8)
  static EdgeInsets get edgeInsetsAllS =>
      EdgeInsets.all(paddingS.r);

  /// All sides padding - Medium (12)
  static EdgeInsets get edgeInsetsAllM =>
      EdgeInsets.all(paddingM.r);

  /// All sides padding - Large (16)
  static EdgeInsets get edgeInsetsAllL =>
      EdgeInsets.all(paddingL.r);

  /// All sides padding - Extra Large (20)
  static EdgeInsets get edgeInsetsAllXL =>
      EdgeInsets.all(paddingXL.r);

  /// Horizontal padding - Large (16)
  static EdgeInsets get edgeInsetsHorizontalL =>
      EdgeInsets.symmetric(horizontal: paddingL.w);

  /// Horizontal padding - Extra Large (20)
  static EdgeInsets get edgeInsetsHorizontalXL =>
      EdgeInsets.symmetric(horizontal: paddingXL.w);

  /// Vertical padding - Large (16)
  static EdgeInsets get edgeInsetsVerticalL =>
      EdgeInsets.symmetric(vertical: paddingL.h);

  /// Screen edge padding - Standard (16)
  static EdgeInsets get screenPadding =>
      EdgeInsets.symmetric(horizontal: paddingL.w);

  /// Card content padding
  static EdgeInsets get cardContentPadding =>
      EdgeInsets.all(cardPaddingL.r);

  // ============================================
  // PRE-BUILT BORDER RADIUS
  // ============================================

  /// Small border radius
  static BorderRadius get borderRadiusS =>
      BorderRadius.circular(radiusS.r);

  /// Medium border radius (default for most components)
  static BorderRadius get borderRadiusM =>
      BorderRadius.circular(radiusM.r);

  /// Large border radius
  static BorderRadius get borderRadiusL =>
      BorderRadius.circular(radiusL.r);

  /// Extra large border radius
  static BorderRadius get borderRadiusXL =>
      BorderRadius.circular(radiusXL.r);

  /// Extra extra large border radius
  static BorderRadius get borderRadiusXXL =>
      BorderRadius.circular(radiusXXL.r);

  /// Huge border radius
  static BorderRadius get borderRadiusHuge =>
      BorderRadius.circular(radiusHuge.r);

  /// Maximum border radius
  static BorderRadius get borderRadiusMax =>
      BorderRadius.circular(radiusMax.r);

  /// Full circle border radius
  static BorderRadius get borderRadiusCircle =>
      BorderRadius.circular(radiusFullCircle.r);
}
