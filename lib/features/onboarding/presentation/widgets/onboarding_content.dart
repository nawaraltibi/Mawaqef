import 'package:flutter/material.dart';
import '../../../../core/styles/app_colors.dart';

/// Onboarding Content Widget
/// Displays a single onboarding page with title, description, and icon
class OnboardingContent extends StatelessWidget {
  /// Title of the onboarding page
  final String title;

  /// Description text
  final String description;

  /// Optional icon path or identifier
  final String? icon;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Spacer to push content to center
            const Spacer(flex: 2),

            // Icon or illustration placeholder
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.lightBlue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconData(),
                size: 100,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 64),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 24),

            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.secondaryText,
                height: 1.5,
              ),
            ),

            // Spacer to balance layout
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  /// Get icon data based on page content
  IconData _getIconData() {
    if (icon != null) {
      // Could extend this to use custom icons
      switch (icon) {
        case 'location':
          return Icons.location_on_rounded;
        case 'reserve':
          return Icons.bookmark_rounded;
        case 'manage':
          return Icons.business_center_rounded;
        default:
          return Icons.local_parking;
      }
    }
    return Icons.local_parking;
  }
}

