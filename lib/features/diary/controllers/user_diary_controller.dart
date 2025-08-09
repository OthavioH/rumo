import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';

final userDiaryControllerProvider =
    AsyncNotifierProvider.autoDispose<UserDiaryController, List<DiaryModel>>(
      UserDiaryController.new,
    );

class UserDiaryController extends AutoDisposeAsyncNotifier<List<DiaryModel>> {
  final _diaryRepository = DiaryRepository();

  @override
  FutureOr<List<DiaryModel>> build() {
    final userId = AuthRepository().getCurrentUser()?.uid;
    if (userId == null) return [];

    return _diaryRepository.getUserDiaries(userId: userId);
  }

  void deleteDiary(String diaryId) {
    final diaries = state.valueOrNull;
    if (diaries == null || diaries.isEmpty) return;

    state = AsyncValue.data(
      diaries.where((diary) => diary.id != diaryId).toList(),
    );
  }
}
