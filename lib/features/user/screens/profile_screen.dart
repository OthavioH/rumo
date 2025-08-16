import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/user/controllers/profile_controller.dart';
import 'package:rumo/features/user/widgets/sign_out_bottom_sheet.dart';
import 'package:rumo/repositories/image_upload_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Builder(
                builder: (context) {
                  final userAsync = ref.watch(profileControllerProvider);
                  if (userAsync.isLoading) {
                    return CircularProgressIndicator();
                  }
                  final user = userAsync.valueOrNull;
                  return InkWell(
                    onTap: () async {
                      final imagePicker = ImagePicker();

                      final file = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (file == null) return;

                      final image = File(file.path);

                      final imageUrl = await ImageUploadRepository().uploadImage(image);

                      ref.read(profileControllerProvider.notifier).changeImage(imageUrl);
                    },
                    child: Container(
                      color: Colors.grey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 16,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              user?.photoURL ?? '',
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: Color(0xFF7584FA), shape: BoxShape.circle),
                                  child: SvgPicture.asset(
                                    AssetImages.iconCamera,
                                    fit: BoxFit.cover,
                                    width: 28,
                                    height: 28,
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Text('Toque para alterar a foto'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              OutlinedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SignOutBottomSheet();
                    },
                  );
                },
                style: OutlinedButton.styleFrom(minimumSize: Size.fromHeight(48)),
                child: Text('Sair'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
