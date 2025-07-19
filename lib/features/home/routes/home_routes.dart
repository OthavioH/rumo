
import 'package:flutter/material.dart';
import 'package:rumo/features/home/screens/home_screen.dart';

class HomeRoutes {
  static const String homeScreen = "/home";

  static final Map<String, Widget Function(BuildContext)> routes = {
    homeScreen: (context) => const HomeScreen(),
  };
}