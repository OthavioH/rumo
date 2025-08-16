import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumo/features/diary/models/create_diary_model.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
import 'package:rumo/features/diary/models/update_diary_model.dart';

class DiaryRepository {
  late final FirebaseFirestore firestore;

  DiaryRepository() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> createDiary({required CreateDiaryModel diary}) async {
    try {
      final docRef = await firestore.collection("diaries").add(diary.toMap());
      log("Diary created with ID: ${docRef.id}");
    } catch (e, stackTrace) {
      log("Error creating diary", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateDiary({required UpdateDiaryModel diary}) async {
    try {
      await firestore.collection("diaries").doc(diary.diaryId).update(diary.toMap());
      log("Diary updated with ID: ${diary.diaryId}");
    } catch (e, stackTrace) {
      log("Error updating diary", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<DiaryModel>> getUserDiaries({
    required String userId,
    bool includePrivates = false,
  }) async {
    try {
      Query<Map<String, dynamic>> query = firestore
          .collection("diaries")
          .where(
            "ownerId",
            isEqualTo: userId,
          );

      if (!includePrivates) {
        query = query.where("isPrivate", isEqualTo: false);
      }
      final querySnapshot = await query.get();
      if (querySnapshot.size <= 0) {
        return [];
      }
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        final id = doc.id;
        data['id'] = id;
        return DiaryModel.fromJson(data);
      }).toList();
    } catch (e) {
      log("Error fetching user diaries", error: e);
      rethrow;
    }
  }

  Future<List<DiaryModel>> getAllUsersDiaries() async {
    try {
      final querySnapshot = await firestore.collection("diaries").where("isPrivate", isEqualTo: false).get();
      if (querySnapshot.size <= 0) {
        return [];
      }
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        final id = doc.id;
        data['id'] = id;
        return DiaryModel.fromJson(data);
      }).toList();
    } catch (e) {
      log("Error fetching user diaries", error: e);
      rethrow;
    }
  }

  Future<List<DiaryModel>> getFollowingsDiaries({
    required String userId,
  }) async {
    try {
      final followingsQuery = await firestore.collection("follows").where("userId", isEqualTo: userId).get();
      if (followingsQuery.size <= 0) {
        return [];
      }
      List<DiaryModel> diaries = [];

      for (var followDoc in followingsQuery.docs) {
        final targetUserId = followDoc.data()['targetUserId'] as String?;

        if (targetUserId == null) continue;

        final userDiaries = await getUserDiaries(userId: targetUserId);
        diaries.addAll(userDiaries);
      }

      return diaries;
    } catch (e) {
      log("Error fetching user diaries", error: e);
      rethrow;
    }
  }

  Future<void> deleteDiary({required String diaryId}) async {
    try {
      return firestore.collection("diaries").doc(diaryId).delete();
    } catch (error, stackTrace) {
      log("Error deleting diary", error: error, stackTrace: stackTrace);
    }
  }
}
