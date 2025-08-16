import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/diary/screens/user_diaries_list_view/widgets/user_info_chip/user_info_notifier.dart';
import 'package:rumo/widgets/bottom_sheet_drag_widget.dart';
// import 'package:skeletonizer/skeletonizer.dart';

class UserStatsBottomSheet extends StatelessWidget {
  const UserStatsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.3,
      minChildSize: 0.3,
      builder: (context, controller) {
        return SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomSheetDragWidget(),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: 20),
                    controller: controller,
                    children: [
                      Consumer(
                        builder: (_, WidgetRef ref, __) {
                          final user = ref.watch(userInfoProvider).valueOrNull;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  user?.photoURL ?? '',
                                  width: 42,
                                  height: 42,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: Color(0xFF7584FA), shape: BoxShape.circle),
                                      child: SvgPicture.asset(
                                        AssetImages.iconCamera,
                                        fit: BoxFit.cover,
                                        width: 22,
                                        height: 22,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  user?.displayName ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    color: Color(0xFF131927),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 16,
                        alignment: WrapAlignment.spaceEvenly,
                        runSpacing: 16,
                        children: [
                          _UserStats(
                            data: 0,
                            title: 'Diários',
                          ),
                          _UserStats(
                            data: 0,
                            title: 'Seguidores',
                          ),
                          _UserStats(
                            data: 0,
                            title: 'Seguindo',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _UserStats extends StatelessWidget {
  final String title;
  final int data;
  const _UserStats({
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          Text(
            data.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFF4E61F6),
            ),
            softWrap: false,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}
