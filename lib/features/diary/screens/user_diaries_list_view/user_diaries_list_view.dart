import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final DraggableScrollableController scrollController =
      DraggableScrollableController();

  final double minSize = 0.3;
  double size = 0.3;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    setState(() {
      size = scrollController.size;
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: minSize,
      minChildSize: minSize,
      controller: scrollController,
      builder: (context, controller) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: size < 0.9
                ? BorderRadius.vertical(top: Radius.circular(32))
                : BorderRadius.zero,
          ),
          child: ListView(
            controller: controller,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              Builder(
                builder: (context) {
                  if (size < 0.9) {
                    return SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 14,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          scrollController.animateTo(
                            minSize,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 2,
                            right: 2,
                            bottom: 2,
                          ),
                          child: SvgPicture.asset(
                            AssetImages.iconChevronDown,
                    
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  if(size >= 0.9) {
                    return SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: Center(
                      child: Container(
                        width: 87,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  );
                }
              ),
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
                          loading: () => Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
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
          ),
        );
      },
    );
  }
}
