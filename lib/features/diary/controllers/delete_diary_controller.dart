import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';

final deleteDiaryControllerProvider =
    AsyncNotifierProvider.autoDispose<DeleteDiaryController, void>(
      DeleteDiaryController.new,
    );

class DeleteDiaryController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  void deleteDiary(String diaryId) async {
    try {
      state = AsyncValue.loading();
      await DiaryRepository().deleteDiary(diaryId: diaryId);
      state = AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
