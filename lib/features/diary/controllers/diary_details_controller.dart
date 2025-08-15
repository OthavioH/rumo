
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/diary/models/diary_model.dart';

final diaryDetailsControllerProvider = AsyncNotifierProvider.autoDispose<DiaryDetailsController, DiaryModel?>(
  DiaryDetailsController.new,
);

class DiaryDetailsController extends AutoDisposeAsyncNotifier<DiaryModel?> {
  @override
  FutureOr<DiaryModel?> build() {
    return Future.delayed(Duration(seconds: 1), () => null);
  }
}