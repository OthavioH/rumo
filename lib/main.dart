import 'package:flutter/material.dart';
import 'package:rumo/features/onboarding/routes/onboarding_routes.dart';
import 'package:rumo/routes/app_router.dart';
import 'package:rumo/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rumo',
      theme: AppTheme().theme,
      routes: AppRouter.routes,
      initialRoute: OnboardingRoutes.onboardingScreen,
    );
  }
}
