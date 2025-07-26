import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_images.dart';

class CreateDiaryBottomSheet extends StatefulWidget {
  const CreateDiaryBottomSheet({super.key});

  @override
  State<CreateDiaryBottomSheet> createState() => _CreateDiaryBottomSheetState();
}

class _CreateDiaryBottomSheetState extends State<CreateDiaryBottomSheet> {
  InputDecoration iconTextFieldDecoration({
    required Widget icon,
    required String hintText,
  }) => InputDecoration(
    prefixIcon: Padding(
      padding: const EdgeInsets.only(
        top: 17.5,
        bottom: 17.5,
        left: 12,
        right: 6,
      ),
      child: icon,
    ),
    prefixIconConstraints: BoxConstraints(maxWidth: 48),
    hintText: hintText,
  );

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
            bottom: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Novo Diário',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {},
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
        Container(
          height: 94,
          color: Color(0xFFCED4FF),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [Color(0xFFCED4FF), Color(0xFFFFFFFF)],
          //     stops: [0.0, 1.0],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //   ),
          // ),
          child: Center(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                // fixedSize: Size(170, 24),
                minimumSize: Size.zero,
                backgroundColor: Color(0xFF4E61F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              ),
              onPressed: () {},
              label: Text('Escolher uma foto de capa'),
              icon: SvgPicture.asset(
                AssetImages.iconCamera,
                width: 16,
                height: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              TextFormField(
                decoration: iconTextFieldDecoration(
                  icon: SvgPicture.asset(
                    AssetImages.iconLocationPin,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                  hintText: 'Localização',
                ),
              ),
              TextFormField(
                decoration: iconTextFieldDecoration(
                  icon: SvgPicture.asset(
                    AssetImages.iconTag,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                  hintText: 'Nome da sua viagem',
                ),
              ),
              TextFormField(
                minLines: 4,
                maxLines: 4,
                decoration: iconTextFieldDecoration(
                  icon: SvgPicture.asset(
                    AssetImages.iconThreeLines,
                    width: 16,
                    height: 16,
                    fit: BoxFit.cover,
                  ),
                  hintText: 'Resumo da sua viagem',
                ),
              ),
              TextFormField(
                decoration: iconTextFieldDecoration(
                  icon: SvgPicture.asset(
                    AssetImages.iconPhoto,
                    width: 18,
                    height: 18,
                    fit: BoxFit.cover,
                  ),
                  hintText: 'Imagens da sua viagem',
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFD9D9D9), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Nota para a viagem'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AssetImages.iconStar,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            Color(0xFFFFCB45),
                            BlendMode.srcIn,
                          ),
                        ),
                        SvgPicture.asset(
                          AssetImages.iconStar,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            Color(0xFFFFCB45),
                            BlendMode.srcIn,
                          ),
                        ),
                        SvgPicture.asset(
                          AssetImages.iconHalfStar,
                          width: 24,
                          height: 24,
                        ),
                        SvgPicture.asset(
                          AssetImages.iconStar,
                          width: 24,
                          height: 24,
                        ),
                        SvgPicture.asset(
                          AssetImages.iconStar,
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(onPressed: () {}, child: Text('Salvar Diário')),
            ],
          ),
        ),
      ],
    ),
  );
}
