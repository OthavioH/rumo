import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumo/features/diary/models/create_diary_model.dart';

class DiaryRepository {
  Future createDiary({required CreateDiaryModel diary}) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final docRef = await firestore.collection("diaries").add(diary.toMap());
      log("Diary created with ID: ${docRef.id}");
    }  catch (e, stackTrace) {
      log("Error creating diary", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
