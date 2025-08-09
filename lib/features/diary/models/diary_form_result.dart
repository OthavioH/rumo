import 'dart:io';

import 'package:rumo/features/diary/models/place.dart';

class DiaryFormResult {
  final File selectedImage;
  final List<File> tripImages;
  final String ownerId;
  final Place? selectedPlace;
  final String name;
  final String resume;
  final double rating;
  final bool isPrivate;
  final double? latitude;
  final double? longitude;

  DiaryFormResult({
    required this.selectedImage,
    required this.tripImages,
    required this.ownerId,
    required this.selectedPlace,
    required this.name,
    required this.resume,
    required this.rating,
    required this.isPrivate,
    required this.latitude,
    required this.longitude,
  });
}