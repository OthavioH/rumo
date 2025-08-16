import 'package:rumo/features/user/models/user_model.dart';

class FollowModel {
  final String id;
  final UserModel? user;
  final UserModel? targetUser;

  FollowModel({
    required this.id,
    required this.user,
    required this.targetUser,
  });

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      id: json['id'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      targetUser: json['targetUser'] != null ? UserModel.fromJson(json['targetUser']) : null,
    );
  }
}
