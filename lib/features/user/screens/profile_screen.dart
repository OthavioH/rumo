import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
    final userAsync = ref.watch(profileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Builder(
                builder: (context) {
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
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 16,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              imageUrl: user?.photoURL ?? '',
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorWidget: (context, error, stackTrace) {
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
                            child: Text(
                              'Toque para alterar a foto',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(16),
                child: Builder(
                  builder: (context) {
                    if (userAsync.isLoading) {
                      return CircularProgressIndicator();
                    }
                    final user = userAsync.valueOrNull;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Nome: ',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Color(0xFF767676),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            (user?.displayName ?? ''),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 80),
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
