import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';

final communityDiariesMapControllerProvider = AsyncNotifierProvider.autoDispose.family<CommunityDiariesMapController, List<DiaryModel>, DiaryFilter>(
  CommunityDiariesMapController.new,
);

class CommunityDiariesMapController extends AutoDisposeFamilyAsyncNotifier<List<DiaryModel>, DiaryFilter> {
  final _diaryRepository = DiaryRepository();

  @override
  FutureOr<List<DiaryModel>> build(DiaryFilter filter) async {
    final user = await AuthRepository().getCurrentUser();
    if (user?.uid == null) {
      return [];
    }
    final userId = user!.uid;
    final list = switch (filter) {
      DiaryFilter.following => _diaryRepository.getFollowingsDiaries(userId: userId),
      DiaryFilter.followers => _diaryRepository.getFollowersDiaries(targetUserId: userId),
      DiaryFilter.all => _diaryRepository.getFollowersAndFollowingDiaries(userId: userId),
    };

    return list;
  }
}

enum DiaryFilter { all, following, followers }
