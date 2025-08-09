import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/diary/models/diary_model.dart';

class UserDiary extends StatelessWidget {
  final DiaryModel diary;
  const UserDiary({super.key, required this.diary});

  @override
  Widget build(BuildContext context) => ListTile(
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        diary.coverImage,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          diary.name,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        Text(
          diary.location,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    ),
    trailing: IconButton(
      onPressed: () {},
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: SvgPicture.asset(AssetImages.iconDotsMenu, width: 20, height: 20),
    ),
  );
}
