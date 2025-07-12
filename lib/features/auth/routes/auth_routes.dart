
import 'package:flutter/material.dart';
import 'package:rumo/features/auth/create_account/create_account_screen.dart';
import 'package:rumo/features/auth/login/login_screen.dart';

class AuthRoutes {
  static const String createAccountScreen = "/create-account";
  static const String loginScreen = "/login";

  static final Map<String, Widget Function(BuildContext)> routes = {
    createAccountScreen: (context) => const CreateAccountScreen(),
    loginScreen: (context) => const LoginScreen(),
  };
}