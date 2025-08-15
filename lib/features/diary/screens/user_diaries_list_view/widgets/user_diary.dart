import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/diary/controllers/user_diary_controller.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
import 'package:rumo/features/diary/routes/diary_routes.dart';
import 'package:rumo/features/diary/screens/user_diaries_list_view/widgets/delete_diary_bottom_sheet.dart';
import 'package:rumo/features/diary/widgets/edit_diary_bottom_sheet.dart';

class UserDiary extends ConsumerWidget {
  final DiaryModel diary;
  const UserDiary({super.key, required this.diary});

  @override
  Widget build(BuildContext context, ref) => ListTile(
    onTap: () {
      Navigator.pushNamed(context, DiaryRoutes.diaryDetailsScreen);
    },
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
    trailing: MenuAnchor(
      alignmentOffset: Offset(-60, 0),
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              backgroundColor: Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              builder: (context) {
                return EditDiaryBottomSheet(diary: diary);
              },
            );
          },
          child: Text("Editar diário"),
        ),
        Divider(color: Color(0xFFD9D9D9), thickness: 1),
        MenuItemButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              backgroundColor: Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              builder: (context) {
                return DeleteDiaryBottomSheet(
                  diaryId: diary.id,
                  onDelete: (String diaryId) {
                    ref
                        .read(userDiaryControllerProvider.notifier)
                        .deleteDiary(diaryId);
                  },
                );
              },
            );
          },
          child: Text("Excluir diário"),
        ),
      ],
      builder: (context, controller, _) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          style: IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: SvgPicture.asset(
            AssetImages.iconDotsMenu,
            width: 20,
            height: 20,
          ),
        );
      },
    ),
  );
}
