import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';

final userInfoProvider = AsyncNotifierProvider.autoDispose<UserInfoNotifier, User?>(UserInfoNotifier.new);

class UserInfoNotifier extends AutoDisposeAsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    return AuthRepository().getCurrentUser();
  }
}
