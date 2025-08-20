import 'package:flutter/material.dart';

class AppStyles {
  // Title for onboarding pages
  static TextStyle onboardingTitle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  // Subtitle for onboarding pages
  static TextStyle onboardingSubtitle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
  }

  // Button text
  static TextStyle buttonText(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimary,
        );
  }

  // General headline
  static TextStyle headlineLarge(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }

  // General subtitle
  static TextStyle subtitle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
  }
}
