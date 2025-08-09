import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      await Future.delayed(Duration(seconds: 5), () {});
      state = AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
