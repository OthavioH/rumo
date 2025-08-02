import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumo/features/diary/models/create_diary_model.dart';
import 'package:rumo/features/diary/models/diary_model.dart';

class DiaryRepository {
  late final FirebaseFirestore firestore;

  DiaryRepository() {
    firestore = FirebaseFirestore.instance;
  }

  Future createDiary({required CreateDiaryModel diary}) async {
    try {
      final docRef = await firestore.collection("diaries").add(diary.toMap());
      log("Diary created with ID: ${docRef.id}");
    } catch (e, stackTrace) {
      log("Error creating diary", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<DiaryModel>> getUserDiaries({required String userId}) async {
    try {
      final querySnapshot = await firestore
          .collection("diaries")
          .where("ownerId", isEqualTo: userId)
          .get();
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
}
