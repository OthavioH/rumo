import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
import 'package:rumo/features/diary/models/update_diary_model.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';

final userDiaryControllerProvider =
    AsyncNotifierProvider.autoDispose<UserDiaryController, List<DiaryModel>>(
      UserDiaryController.new,
    );

class UserDiaryController extends AutoDisposeAsyncNotifier<List<DiaryModel>> {
  final _diaryRepository = DiaryRepository();

  @override
  FutureOr<List<DiaryModel>> build() async {
    final user = await AuthRepository().getCurrentUser();
    final userId = user?.uid;
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

  void updateDiary(UpdateDiaryModel updatedDiaryModel) {
    final diaries = state.valueOrNull;
    if (diaries == null || diaries.isEmpty) return;

    final diaryIndex = diaries.indexWhere((diary) => diary.id == updatedDiaryModel.diaryId);
    if (diaryIndex == -1) return;

    final updatedDiary = DiaryModel(
      id: updatedDiaryModel.diaryId,
      ownerId: updatedDiaryModel.ownerId,
      location: updatedDiaryModel.location,
      name: updatedDiaryModel.name,
      coverImage: updatedDiaryModel.coverImage,
      resume: updatedDiaryModel.resume,
      images: updatedDiaryModel.images,
      rating: updatedDiaryModel.rating,
      latitude: updatedDiaryModel.latitude,
      longitude: updatedDiaryModel.longitude,
      isPrivate: updatedDiaryModel.isPrivate,
    );

    diaries[diaryIndex] = updatedDiary;

    state = AsyncValue.data(
      diaries,
    );
  }
}
