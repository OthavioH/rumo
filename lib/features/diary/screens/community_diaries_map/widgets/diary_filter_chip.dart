import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/diary/screens/community_diaries_map/community_diaries_map_controller.dart';
import 'package:rumo/features/diary/screens/user_diaries_list_view/widgets/user_info_chip/user_info_notifier.dart';

class DiaryFilterChip extends ConsumerWidget {
  final DiaryFilter currentFilter;
  final void Function(DiaryFilter) onChangeFilter;
  const DiaryFilterChip({
    super.key,
    required this.currentFilter,
    required this.onChangeFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userInfoProvider);
    if (userAsync.valueOrNull == null) {
      return SizedBox.shrink();
    }

    final user = userAsync.value!;
    return MenuAnchor(
      alignmentOffset: Offset(currentFilter != DiaryFilter.all ? -20 : 0, 10),
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            if(currentFilter == DiaryFilter.followers) {
              onChangeFilter(DiaryFilter.all);
              return;
            }
            onChangeFilter(DiaryFilter.followers);
          },
          leadingIcon: currentFilter == DiaryFilter.followers ? Icon(Icons.check) : null,
          child: Text('Seguidores'),
        ),
        Divider(color: Color(0xFFD9D9D9), thickness: 1),
        MenuItemButton(
          onPressed: () {
            if(currentFilter == DiaryFilter.following) {
              onChangeFilter(DiaryFilter.all);
              return;
            }
            onChangeFilter(DiaryFilter.following);
          },
          leadingIcon: currentFilter == DiaryFilter.following ? Icon(Icons.check) : null,
          child: Text('Seguindo'),
        ),
      ],
      builder: (context, controller, _) {
        return InkWell(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 4,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: user.photoURL ?? '',
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Color(0xFF7584FA), shape: BoxShape.circle),
                        child: SvgPicture.asset(
                          AssetImages.iconCamera,
                          fit: BoxFit.cover,
                          width: 8,
                          height: 8,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Meu mapa',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    color: Color(0xFF131927),
                  ),
                ),

                const SizedBox(width: 10),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
