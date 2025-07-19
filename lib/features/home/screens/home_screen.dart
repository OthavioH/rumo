import 'package:flutter/material.dart';
import 'package:rumo/features/onboarding/routes/onboarding_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(
            context,
          ).pushReplacementNamed(OnboardingRoutes.onboardingScreen);
        },
        child: Text('Logout'),
      ),
    ),
  );
}
