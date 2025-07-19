import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('Resetar senha'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(hintText: 'E-mail'),
          validator: (value) {
            final invalidEmailText = 'Insira um e-mail válido';

            if (value == null || value.trim().isEmpty) {
              return invalidEmailText;
            }

            final email = value.trim();

            if (!email.contains('@') || !email.contains('.')) {
              return invalidEmailText;
            }

            final parts = email.split('@');
            final firstPart = parts[0];

            if (firstPart.trim().isEmpty) {
              return invalidEmailText;
            }

            final lastPart = parts[1];

            if (lastPart.trim().isEmpty || !lastPart.contains('.')) {
              return invalidEmailText;
            }

            if (lastPart.startsWith('.') || lastPart.endsWith('.')) {
              return invalidEmailText;
            }

            return null;
          },
        ),
        const SizedBox(height: 16),
        Visibility(visible: isLoading, child: CircularProgressIndicator()),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });

          try {
            final authRepository = AuthRepository();
            await authRepository.sendPasswordResetEmail(
              email: _emailController.text,
            );
          } catch (error) {
            log("Error resetting password", error: error);
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        },
        child: Text('Enviar e-mail'),
      ),
    ],
  );
}
