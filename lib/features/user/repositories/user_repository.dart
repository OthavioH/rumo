import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumo/features/user/models/user_model.dart';

class UserRepository {
  Future<List<UserModel>> getUsers({
    required String loggedUserId,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore
        .collection('users')
        .where(
          'id',
          isNotEqualTo: loggedUserId,
        )
        .get();

    return snapshot.docs
        .map(
          (doc) => UserModel.fromJson(
            doc.data(),
          ),
        )
        .toList();
  }
}
