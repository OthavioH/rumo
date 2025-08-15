import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/diary/screens/user_diaries_list_view/widgets/user_info_chip/user_info_notifier.dart';

class UserInfoChip extends ConsumerWidget {
  const UserInfoChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userInfoProvider);
    if (userAsync.valueOrNull == null) {
      return SizedBox.shrink();
    }

    final user = userAsync.value!;
    // return Chip(
    //   avatar: ClipRRect(
    //     borderRadius: BorderRadius.circular(50),
    //     clipBehavior: Clip.antiAlias,
    //     child: Image.asset(
    //       user.photoURL ?? AssetImages.onboardingCharacter,
    //       width: 20,
    //       height: 20,
    //       fit: BoxFit.cover,
    //     ),
    //   ),
    //   label: Text(user.displayName ?? ''),
    //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    // );
    return Container(
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
            child: Image.asset(
              user.photoURL ?? AssetImages.onboardingCharacter,
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            user.displayName ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: Color(0xFF131927),
            ),
          ),
        ],
      ),
    );
  }
}
