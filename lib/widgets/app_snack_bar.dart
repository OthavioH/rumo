
import 'package:flutter/material.dart';
import 'package:rumo/theme/app_colors.dart';

class AppSnackBar extends StatelessWidget {
  final Duration duration;
  const AppSnackBar({super.key, required this.duration});

  @override
  Widget build(BuildContext context) => SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: context.appColors?.successColor),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'E-mail de redefinição de senha enviado com sucesso!',
                ),
              ),
            ],
          ),
          margin:  EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height - MediaQuery.viewPaddingOf(context).top - 24 - 70, left: 20.0, right: 20.0), // Margem do topo,
          duration: const Duration(minutes: 1),
        );
}