import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/diary/controllers/user_diary_controller.dart';
import 'package:rumo/features/diary/screens/user_diaries_list_view/widgets/user_diary.dart';

class UserDiariesListView extends ConsumerStatefulWidget {
  const UserDiariesListView({super.key});

  @override
  ConsumerState<UserDiariesListView> createState() =>
      _UserDiariesListViewState();
}

class _UserDiariesListViewState extends ConsumerState<UserDiariesListView> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.3,
      minChildSize: 0.3,
      builder: (context, controller) {
        return ListView(
          controller: controller,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            Text(
              'Meus diários',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF4E61F6),
                borderRadius: BorderRadius.circular(20),
              ),
              width: double.maxFinite,
              height: 107,
              clipBehavior: Clip.antiAlias,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 35,
                children: [
                  Image.asset(AssetImages.diaryCounterCharacter),
                  Builder(
                    builder: (context) {
                      final state = ref.watch(userDiaryControllerProvider);
                      return state.when(
                        error: (error, stackTrace) {
                          return Center(
                            child: Text('Erro ao carregar diários'),
                          );
                        },
                        loading: () =>
                            Center(child: CircularProgressIndicator(
                              color: Colors.white,
                            )),
                        data: (diaries) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                diaries.length.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 42,
                                  color: Colors.white,
                                  height: 1,
                                  letterSpacing: 0,
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  String diaryLabel = diaries.length == 1
                                      ? 'Diário'
                                      : 'Diários';
                                  return Text(
                                    diaryLabel,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                      height: 1,
                                      letterSpacing: 0,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'TODOS OS DIÁRIOS',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                final state = ref.watch(userDiaryControllerProvider);
                return state.when(
                  error: (error, stackTrace) {
                    log(
                      "Erro ao pegar diários",
                      error: error,
                      stackTrace: stackTrace,
                    );
                    return Center(child: Text('Erro ao carregar diários'));
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  data: (diaries) {
                    if (diaries.isEmpty) {
                      return Center(child: Text('Nenhum diário encontrado'));
                    }
                    return ListView.separated(
                      itemCount: diaries.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return UserDiary(diary: diaries[index]);
                      },
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
