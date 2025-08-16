import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/user/models/user_model.dart';
import 'package:rumo/features/user/repositories/follow_repository.dart';

final searchUsersControllerProvider = AsyncNotifierProvider.autoDispose<SearchUsersController, List<FollowingUserTemplate>>(
  SearchUsersController.new,
);

class SearchUsersController extends AutoDisposeAsyncNotifier<List<FollowingUserTemplate>> {
  @override
  FutureOr<List<FollowingUserTemplate>> build() async {
    final user = await AuthRepository().getCurrentUser();
    final userId = user?.uid;
    if (userId == null) {
      return [];
    }
    final followings = await FollowRepository().getFollowings(userId: userId);
    final nonFollowings = await FollowRepository().getNonFollowingUsers(userId: userId);

    List<FollowingUserTemplate> followingUsers = [];

    followingUsers.addAll(
      followings.map(
        (follow) => FollowingUserTemplate(isFollowing: true, user: follow.targetUser),
      ),
    );

    followingUsers.addAll(
      nonFollowings.map(
        (user) => FollowingUserTemplate(isFollowing: false, user: user),
      ),
    );

    return followingUsers;
  }
}

class FollowingUserTemplate {
  final bool isFollowing;
  final UserModel? user;

  FollowingUserTemplate({
    required this.isFollowing,
    required this.user,
  });
}
