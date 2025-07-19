import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  Future createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
    } on FirebaseAuthException catch (error) {
      log(error.message ?? 'Error desconhecido');
      
      throw AuthException(code: error.code);
    }
  }
}

class AuthException implements Exception {
  final String code;
  AuthException({
    required this.code,
  });

  String getMessage() {
    switch (code) {
      case "email-already-in-use":
        return "Email já está em uso";
      default:
        return "Erro desconhecido";
    }
  }
}