
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';

final communityDiariesMapControllerProvider =
    AsyncNotifierProvider.autoDispose<CommunityDiariesMapController, List<DiaryModel>>(
      CommunityDiariesMapController.new,
    );

class CommunityDiariesMapController extends AutoDisposeAsyncNotifier<List<DiaryModel>> {
  final _diaryRepository = DiaryRepository();

  @override
  FutureOr<List<DiaryModel>> build() async {
    final user = await AuthRepository().getCurrentUser();
    if (user?.uid == null) {
      return [];
    }
    final userId = user!.uid;
    return _diaryRepository.getFollowingsDiaries(userId: userId);
  }

}
