import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/diary/controllers/user_diary_controller.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
import 'package:rumo/features/diary/models/update_diary_model.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';
import 'package:rumo/features/diary/widgets/diary_form/diary_form.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class EditDiaryBottomSheet extends StatelessWidget {
  final DiaryModel diary;

  const EditDiaryBottomSheet({super.key, required this.diary});

  void showSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Diário alterado'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void showError(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 24,
            right: 24,
            bottom: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Editar Diário',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                child: Text('Cancelar'),
              ),
            ],
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            return DiaryForm(
              diary: diary,
              buttonTitle: 'Salvar mudanças',
              onError: (message) {
                if (message == null) {
                  showError("Erro ao editar diário", context);
                  return;
                }
                showError(message, context);
              },
              onSubmit: (result) async {
                final coverImageName = result.selectedImage.path
                    .split('/')
                    .last;
                final diaryCoverImageName = diary.coverImage.split('/').last;
                String coverUrl = diary.coverImage;
                if (coverImageName != diaryCoverImageName) {
                  coverUrl = await uploadImage(result.selectedImage);
                }

                List<String> deletedImages = diary.images.where((image) {
                  final imageName = image.split('/').last;
                  return result.tripImages.every((tripImage) {
                    final tripImageName = tripImage.path.split('/').last;
                    return tripImageName != imageName;
                  });
                }).toList();

                final tripImagesUploads = result.tripImages.map((tripImage) {
                  final tripImageName = tripImage.path.split('/').last;
                  final isDuplicated = diary.images.any((image) {
                    final imageName = image.split('/').last;
                    return imageName == tripImageName;
                  });
                  if (!isDuplicated) {
                    return uploadImage(tripImage);
                  }
                }).whereType<Future<String>>();

                final newImagesUrls = await Future.wait(tripImagesUploads);

                final diaryImages = diary.images;

                diaryImages.removeWhere((image) {
                  return deletedImages.contains(image);
                });

                diaryImages.addAll(newImagesUrls);

                final updateDiaryModel = UpdateDiaryModel(
                  diaryId: diary.id,
                  ownerId: result.ownerId,
                  location:
                      result.selectedPlace?.formattedLocation ?? diary.location,
                  name: result.name,
                  coverImage: coverUrl,
                  resume: result.resume,
                  images: diaryImages,
                  rating: result.rating,
                  isPrivate: result.isPrivate,
                  latitude: result.latitude ?? diary.latitude,
                  longitude: result.longitude ?? diary.longitude,
                );

                await DiaryRepository().updateDiary(diary: updateDiaryModel);
                ref
                    .read(userDiaryControllerProvider.notifier)
                    .updateDiary(updateDiaryModel);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  showSuccess(context);
                }
              },
            );
          },
        ),
      ],
    ),
  );

  Future<String> uploadImage(File image) async {
    final fileType = image.path.split('.').last;
    final imageId = Uuid().v4();
    final filename = '$imageId.$fileType';
    final supabase = Supabase.instance.client;
    await supabase.storage.from('images').upload(filename, image);
    return supabase.storage.from('images').getPublicUrl(filename);
  }
}
