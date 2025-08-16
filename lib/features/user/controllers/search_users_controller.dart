import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/user/models/user_model.dart';
import 'package:rumo/features/user/repositories/follow_repository.dart';

final searchUsersControllerProvider = AsyncNotifierProvider.autoDispose<SearchUsersController, List<FollowingUserTemplate>>(
  SearchUsersController.new,
);

class SearchUsersController extends AutoDisposeAsyncNotifier<List<FollowingUserTemplate>> {
  final AuthRepository _authRepository = AuthRepository();
  final FollowRepository _followRepository = FollowRepository();

  @override
  FutureOr<List<FollowingUserTemplate>> build() async {
    final user = await _authRepository.getCurrentUser();
    final userId = user?.uid;
    if (userId == null) {
      return [];
    }
    final followings = await _followRepository.getFollowings(userId: userId);
    final nonFollowings = await _followRepository.getNonFollowingUsers(userId: userId);

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

  void followUser(FollowingUserTemplate userTemplate) async {
    if (userTemplate.user == null) return;
    final localUser = await _authRepository.getCurrentUser();

    if (localUser == null) return;

    userTemplate.isFollowing = true;

    final indexOfTemplate = state.valueOrNull?.indexWhere(
      (element) => element.user?.id == userTemplate.user!.id,
    );

    if (indexOfTemplate == null || indexOfTemplate == -1) return;

    final updatedList = state.valueOrNull!;

    updatedList[indexOfTemplate] = userTemplate;

    state = AsyncData(updatedList);

    await _followRepository.followUser(
      localUser.uid,
      userTemplate.user!.id,
    );
  }

  void unfollowUser(FollowingUserTemplate userTemplate) async {
    if (userTemplate.user == null) return;
    final localUser = await _authRepository.getCurrentUser();

    if (localUser == null) return;

    userTemplate.isFollowing = false;

    final indexOfTemplate = state.valueOrNull?.indexWhere(
      (element) => element.user?.id == userTemplate.user!.id,
    );

    if (indexOfTemplate == null || indexOfTemplate == -1) return;

    final updatedList = state.valueOrNull!;

    updatedList[indexOfTemplate] = userTemplate;

    state = AsyncData(updatedList);

    await _followRepository.unfollowUser(
      localUser.uid,
      userTemplate.user!.id,
    );
  }
}

class FollowingUserTemplate {
  bool isFollowing;
  final UserModel? user;

  FollowingUserTemplate({
    required this.isFollowing,
    required this.user,
  });
}
