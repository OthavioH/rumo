import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/diary/controllers/delete_diary_controller.dart';

class DeleteDiaryBottomSheet extends ConsumerWidget {
  final String diaryId;
  final void Function(String diaryId) onDelete;
  const DeleteDiaryBottomSheet({
    required this.diaryId,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(deleteDiaryControllerProvider, (_, next) {
      next.when(
        error: (error, stackTrace) {
          log("Error on delete diary", error: error, stackTrace: stackTrace);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Algo deu errado')));
        },
        loading: () {},
        data: (_) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Diário excluído')));
          onDelete(diaryId);
        },
      );
    });

    final state = ref.watch(deleteDiaryControllerProvider);
    return SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Excluir Diário'),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFEE443F),
                textStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: state.isLoading
                  ? null
                  : () async {
                      ref
                          .read(deleteDiaryControllerProvider.notifier)
                          .deleteDiary(diaryId);
                    },
              child: state.isLoading
                  ? CircularProgressIndicator()
                  : Text('Excluir diário'),
            ),
          ],
        ),
      ),
    );
  }
}
