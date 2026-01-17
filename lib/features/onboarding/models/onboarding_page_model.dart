/// Onboarding Page Model
/// Represents a single page in the onboarding flow
class OnboardingPageModel {
  /// Title of the onboarding page
  final String title;

  /// Description text of the onboarding page
  final String description;

  /// Icon data (optional) for the page
  final String? icon;

  const OnboardingPageModel({
    required this.title,
    required this.description,
    this.icon,
  });
}

