import 'package:flutter/material.dart';
import '../../../../core/styles/app_colors.dart';

/// Onboarding Indicator Widget
/// Shows page indicators for the onboarding flow
class OnboardingIndicator extends StatelessWidget {
  /// Total number of pages
  final int totalPages;

  /// Current active page index
  final int currentPage;

  const OnboardingIndicator({
    super.key,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => _buildDot(index == currentPage),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

