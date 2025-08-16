import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DiaryComment extends StatelessWidget {
  const DiaryComment({super.key});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(16)),

    padding: const EdgeInsets.all(16),
    child: Column(
      spacing: 12,
      children: [
        Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: 'https://i.pinimg.com/736x/20/2c/93/202c93cc9d7f26578c00f3b350dec976.jpg',
                width: 29,
                height: 29,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'Liora',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF303030),
              ),
            ),
          ],
        ),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In laoreet, purus non dictum ornare, nisl justo consectetur dolor, et congue ante lectus a eros.',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Color(0xFF757575)),
        ),
      ],
    ),
  );
}
