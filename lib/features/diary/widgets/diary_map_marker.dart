import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_images.dart';

class DiaryMapMarker extends StatelessWidget {
  final String imageUrl;
  final bool isFromLoggedUser;
  const DiaryMapMarker({
    required this.imageUrl,
    required this.isFromLoggedUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset(
            AssetImages.mapPinBackground,
            colorFilter: isFromLoggedUser
                ? null
                : ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 13, left: 14, right: 14),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
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
