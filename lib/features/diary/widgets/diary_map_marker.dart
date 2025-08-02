import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_images.dart';

class DiaryMapMarker extends StatelessWidget {
  final String imageUrl;
  const DiaryMapMarker({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: SvgPicture.asset(AssetImages.mapPinBackground)),
        Padding(
          padding: const EdgeInsets.only(bottom: 13, left: 14, right: 14),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  imageUrl,
                ),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
