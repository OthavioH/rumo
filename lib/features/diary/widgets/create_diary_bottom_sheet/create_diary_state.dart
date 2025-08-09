import 'package:rumo/features/diary/models/place.dart';

abstract class CreateDiaryState {}

class CreateDiaryInitial extends CreateDiaryState {}

class CreateDiaryLoading extends CreateDiaryState {}

class CreateDiarySuccess extends CreateDiaryState {
  final List<Place> places;

  CreateDiarySuccess({required this.places});
}

class CreateDiaryError extends CreateDiaryState {
  final String message;

  CreateDiaryError({required this.message});
}
