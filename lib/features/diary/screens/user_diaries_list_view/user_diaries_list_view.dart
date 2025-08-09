import 'package:flutter/material.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';
import 'package:rumo/features/diary/screens/user_diaries_list_view/widgets/user_diary.dart';

class UserDiariesListView extends StatefulWidget {
  const UserDiariesListView({super.key});

  @override
  State<UserDiariesListView> createState() => _UserDiariesListViewState();
}

class _UserDiariesListViewState extends State<UserDiariesListView> {
  final diaryRepository = DiaryRepository();

  List<DiaryModel> diaries = [];

  @override
  void initState() {
    super.initState();
    fetchDiaries();
  }

  void fetchDiaries() async {
    final userId = AuthRepository().getCurrentUser()?.uid;
    if (userId == null) return;

    final fetchedDiaries = await diaryRepository.getUserDiaries(userId: userId);
    if (mounted) {
      setState(() {
        diaries = fetchedDiaries;
      });
    }
  }

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
              color: Colors.blue,
              width: double.maxFinite,
              height: 107,
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
            ),
          ],
        );
      },
    );
  }
}
