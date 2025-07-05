
import 'package:flutter/material.dart';
import 'package:rumo/features/auth/create_account/create_account_screen.dart';

class AuthRoutes {
  static const String createAccountScreen = "/create-account";

  static final Map<String, Widget Function(BuildContext)> routes = {
    createAccountScreen: (context) => const CreateAccountScreen(),
  };
}