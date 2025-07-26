import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rumo/features/onboarding/routes/onboarding_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: OutlinedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    width: double.maxFinite,
                    child: TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          Navigator.of(context).popUntil((_) => false);
                          Navigator.pushNamed(
                            context,
                            OnboardingRoutes.onboardingScreen,
                          );
                        }
                      },
                      child: Text("Sair da minha conta"),
                    ),
                  );
                },
              );
            },
            child: Text('Sair'),
            style: OutlinedButton.styleFrom(minimumSize: Size.fromHeight(48)),
          ),
        ),
      ),
    );
  }
}
