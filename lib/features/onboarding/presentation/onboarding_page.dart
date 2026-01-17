import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../data/repositories/settings_local_repository.dart';
import 'widgets/onboarding_content.dart';
import 'widgets/onboarding_indicator.dart';

/// Onboarding Page
/// Displays a multi-screen onboarding flow for first-time users
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// Total number of onboarding pages
  static const int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Navigate to the next page or complete onboarding
  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  /// Skip onboarding and navigate to login
  void _skipOnboarding() {
    _completeOnboarding();
  }

  /// Complete onboarding and navigate to login screen
  void _completeOnboarding() {
    // Mark onboarding as completed
    SettingsLocalRepository.markOnboardingCompleted();
    
    // Navigate to login screen
    if (mounted) {
      context.go(Routes.loginPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Get onboarding content based on current page
    List<Map<String, String>> pages = [
      {
        'title': l10n.onboardingTitle1,
        'description': l10n.onboardingDescription1,
        'icon': 'location',
      },
      {
        'title': l10n.onboardingTitle2,
        'description': l10n.onboardingDescription2,
        'icon': 'reserve',
      },
      {
        'title': l10n.onboardingTitle3,
        'description': l10n.onboardingDescription3,
        'icon': 'manage',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button at the top
            if (_currentPage < _totalPages - 1)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      l10n.skip,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

            // PageView for onboarding screens
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return OnboardingContent(
                    title: page['title']!,
                    description: page['description']!,
                    icon: page['icon'],
                  );
                },
              ),
            ),

            // Bottom section with indicators and navigation button
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  // Page indicators
                  OnboardingIndicator(
                    totalPages: _totalPages,
                    currentPage: _currentPage,
                  ),

                  const SizedBox(height: 32),

                  // Next/Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage < _totalPages - 1
                            ? l10n.next
                            : l10n.getStarted,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
