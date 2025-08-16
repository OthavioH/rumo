
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/user/models/user_model.dart';
import 'package:rumo/features/user/repositories/user_repository.dart';

final searchUsersControllerProvider = AsyncNotifierProvider.autoDispose<SearchUsersController, List<UserModel>>(SearchUsersController.new);

class SearchUsersController extends AutoDisposeAsyncNotifier<List<UserModel>> {
  @override
  FutureOr<List<UserModel>> build() async {
    final user = await AuthRepository().getCurrentUser();
    final userId = user?.uid;
    if(userId == null) {
      return [];
    }
    return UserRepository().getUsers(loggedUserId: userId);
  }
}