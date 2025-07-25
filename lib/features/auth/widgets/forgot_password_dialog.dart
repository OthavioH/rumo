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
  String? errorMessage;

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
        ForgotPasswordStatus(isLoading: isLoading, errorMessage: errorMessage),
      ],
    ),
    actions: [
      TextButton(
        onPressed: isLoading
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });

                try {
                  final authRepository = AuthRepository();
                  await authRepository.sendPasswordResetEmail(
                    email: _emailController.text,
                  );
                  if(context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('E-mail de redefinição de senha enviado com sucesso!')),
                    );
                  }
                } on AuthException catch (error) {
                  log("Error resetting password", error: error);
                  setState(() {
                    errorMessage = error.getMessage();
                  });
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

class ForgotPasswordStatus extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  const ForgotPasswordStatus({
    super.key,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator(color: Theme.of(context).colorScheme.inverseSurface);
    }

    if (errorMessage != null) {
      return Text(errorMessage!, style: TextStyle(color: Colors.red));
    }

    return SizedBox.shrink();
  }
}
