import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumo/features/user/models/follow_model.dart';
import 'package:rumo/features/user/models/user_model.dart';

class FollowRepository {
  late final FirebaseFirestore firestore;

  FollowRepository() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> followUser(String userId, String targetUserId) async {
    await firestore.collection("follows").add({
      "userId": userId,
      "targetUserId": targetUserId,
    });
  }

  Future<void> unfollowUser(String userId, String targetUserId) async {
    final query = await firestore
        .collection("follows")
        .where(
          "userId",
          isEqualTo: userId,
        )
        .where(
          "targetUserId",
          isEqualTo: targetUserId,
        )
        .get();

    if (query.docs.isEmpty) {
      throw Exception("Follow relationship not found");
    }

    final doc = query.docs.firstOrNull;

    if (doc == null) {
      throw Exception("Follow relationship not found");
    }

    await doc.reference.delete();
  }

  Future<List<FollowModel>> getFollowings({
    required String userId,
  }) async {
    final query = await firestore
        .collection("follows")
        .where(
          "userId",
          isEqualTo: userId,
        )
        .get();

    if (query.size <= 0) {
      return [];
    }

    final List<FollowModel> followers = [];

    for (var doc in query.docs) {
      final docJSON = doc.data();
      final userId = docJSON['targetUserId'];
      final userSnapshot = await firestore.collection("users").doc(userId).get();
      if (!userSnapshot.exists) {
        continue;
      }

      final userJSON = userSnapshot.data();

      docJSON['targetUser'] = userJSON;
      docJSON['id'] = doc.id;

      final followModel = FollowModel.fromJson(docJSON);
      followers.add(followModel);
    }

    return followers;
  }

  Future<List<UserModel>> getNonFollowingUsers({
    required String userId,
  }) async {
    final followings = await getFollowings(userId: userId);
    final followingUserIds = followings
        .map(
          (follow) => follow.targetUser?.id,
        )
        .toList();

    QuerySnapshot<Map<String, dynamic>> userQuery;

    if (followingUserIds.isEmpty) {
      userQuery = await firestore
          .collection("users")
          .where(
            FieldPath.documentId,
            isNotEqualTo: userId,
          )
          .get();
    } else {
      followingUserIds.add(userId);
      userQuery = await firestore
          .collection("users")
          .where(
            FieldPath.documentId,
            whereNotIn: followingUserIds,
          )
          .get();
    }
    if (userQuery.size <= 0) {
      return [];
    }

    return userQuery.docs.map((doc) {
      final userJSON = doc.data();
      return UserModel.fromJson(userJSON);
    }).toList();
  }
}
