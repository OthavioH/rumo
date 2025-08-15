import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumo/features/diary/controllers/delete_diary_controller.dart';

class DeleteDiaryBottomSheet extends ConsumerWidget {
  final String diaryId;
  final void Function(String diaryId) onDelete;
  const DeleteDiaryBottomSheet({required this.diaryId, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(deleteDiaryControllerProvider, (_, next) {
      next.when(
        error: (error, stackTrace) {
          log("Error on delete diary", error: error, stackTrace: stackTrace);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Algo deu errado')));
        },
        loading: () {},
        data: (_) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Diário excluído')));
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Excluir Diário',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.close),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Todas as informações registradas nele serão perdidas de forma definitiva.",
              style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xFF757575)),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            const SizedBox(height:12),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFFEE443F),
                  textStyle: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600),
                ),
                onPressed: state.isLoading
                    ? null
                    : () async {
                        ref.read(deleteDiaryControllerProvider.notifier).deleteDiary(diaryId);
                      },
                child: state.isLoading ? CircularProgressIndicator() : Text('Excluir diário'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
