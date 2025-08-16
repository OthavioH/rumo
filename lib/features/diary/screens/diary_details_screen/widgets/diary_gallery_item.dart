import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DiaryGalleryItem extends StatelessWidget {
  const DiaryGalleryItem({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 107,
    height: 107,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: "https://media.cnn.com/api/v1/images/stellar/prod/220322112925-brazil-unexpected-places-09-swap.jpg?c=original",
        fit: BoxFit.cover,
      ),
    ),
  );
}
