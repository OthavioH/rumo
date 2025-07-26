import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rumo/features/onboarding/routes/onboarding_routes.dart';

class SignOutBottomSheet extends StatelessWidget {
  const SignOutBottomSheet({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.maxFinite,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Sair da conta',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(Icons.close),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Tem certeza que deseja sair?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Permanecer na minha conta"),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFEE443F),
                textStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
          ),
        ],
      ),
    ),
  );
}
