import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';

final profileControllerProvider = AsyncNotifierProvider.autoDispose<ProfileController, User?>(
  ProfileController.new,
);

class ProfileController extends AutoDisposeAsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    return AuthRepository().getCurrentUser();
  }

  void changeImage(String imageUrl) async {
    try {
      state = AsyncValue.loading();
      await AuthRepository().changeUserImage(imageUrl);
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
