import 'package:flutter/material.dart';

class BottomSheetDragWidget extends StatelessWidget {
  const BottomSheetDragWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.22,
        constraints: BoxConstraints(
          maxWidth: 87,
        ),
        height: 4,
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
