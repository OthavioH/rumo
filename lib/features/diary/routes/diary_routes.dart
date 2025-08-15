
import 'package:flutter/material.dart';
import 'package:rumo/features/diary/screens/diary_details_screen/diary_details_screen.dart';

class DiaryRoutes {
  static const String diaryDetailsScreen = "/diary/details";

  static final Map<String, Widget Function(BuildContext)> routes = {
    diaryDetailsScreen: (context) => const DiaryDetailsScreen(),
  };
}