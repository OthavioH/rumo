import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';

final userInfoControllerProvider = AsyncNotifierProvider.autoDispose<UserInfoController, User?>(UserInfoController.new);

class UserInfoController extends AutoDisposeAsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    return AuthRepository().getCurrentUser();
  }
}
