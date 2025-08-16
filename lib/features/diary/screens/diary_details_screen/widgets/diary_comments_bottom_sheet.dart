import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rumo/features/diary/screens/diary_details_screen/widgets/diary_comment.dart';
import 'package:rumo/widgets/bottom_sheet_drag_widget.dart';

class DiaryCommentsBottomSheet extends StatelessWidget {
  const DiaryCommentsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, controller) {
        final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: bottomPadding + 16,
          ),
          child: ListView(
            controller: controller,

            children: [
              BottomSheetDragWidget(),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Comentários',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Color(0xFF131927),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ListView.separated(
                itemCount: 3,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return DiaryComment();
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.max,
                spacing: 10,
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
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Deixe seu comentário',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
