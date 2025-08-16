import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/user/models/follow_model.dart';
import 'package:rumo/features/user/repositories/follow_repository.dart';

final followersControllerProvider = AsyncNotifierProvider<FollowersController, List<FollowModel>>(
  FollowersController.new,
);

class FollowersController extends AsyncNotifier<List<FollowModel>> {
  @override
  FutureOr<List<FollowModel>> build() async {
    final user = await AuthRepository().getCurrentUser();
    final userId = user?.uid;

    if (userId == null) {
      return [];
    }

    return FollowRepository().getFollowings(userId: userId);
  }
}
