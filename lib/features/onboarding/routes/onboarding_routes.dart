
import 'package:flutter/material.dart';
import 'package:rumo/features/onboarding/onboarding_screen.dart';

class OnboardingRoutes {
  static const String onboardingScreen = "/";

  static final Map<String, Widget Function(BuildContext)> routes = {
    onboardingScreen: (context) => const OnboardingScreen(),
  };
}