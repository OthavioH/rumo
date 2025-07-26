import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavItem extends StatelessWidget {
  final String icon;
  final String label;
  final int currentSelectedIndex;
  final int index;
  final void Function(int index) onSelectItem;
  const BottomNavItem({
    required this.icon,
    required this.label,
    required this.currentSelectedIndex,
    required this.index,
    required this.onSelectItem,
    super.key,
  });

  bool get isSelected => currentSelectedIndex == index;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;
    final inactiveColor = Color(0xFF757575);
    return InkWell(
      onTap: () => onSelectItem(index),
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                isSelected ? activeColor : inactiveColor,
                BlendMode.srcATop,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
