import 'package:flutter/material.dart';
import 'package:rumo/features/user/widgets/sign_out_bottom_sheet.dart';

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
                  return SignOutBottomSheet();
                },
              );
            },
            style: OutlinedButton.styleFrom(minimumSize: Size.fromHeight(48)),
            child: Text('Sair'),
          ),
        ),
      ),
    );
  }
}