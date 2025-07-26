
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rumo/features/home/screens/home_screen.dart';
import 'package:rumo/features/onboarding/onboarding_screen.dart';

class OnboardingRoutes {
  static const String onboardingScreen = "/";

  static final Map<String, Widget Function(BuildContext)> routes = {
    onboardingScreen: (context) {
      final isLogged = FirebaseAuth.instance.currentUser != null;

      if (isLogged) {
        return const HomeScreen();
      }

      return const OnboardingScreen();
    },
  };
}