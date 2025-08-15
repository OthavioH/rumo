import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 12),
      child: IconButton.filled(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        color: const Color(0xFF383838),
        icon: const Icon(Icons.chevron_left),
      ),
    );
  }
}
