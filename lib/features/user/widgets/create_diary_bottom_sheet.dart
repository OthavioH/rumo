import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/services/location_service.dart';
import 'package:geocoding/geocoding.dart';

class CreateDiaryBottomSheet extends StatefulWidget {
  const CreateDiaryBottomSheet({super.key});

  @override
  State<CreateDiaryBottomSheet> createState() => _CreateDiaryBottomSheetState();
}

class _CreateDiaryBottomSheetState extends State<CreateDiaryBottomSheet> {
  final locationService = LocationService();

  bool isPrivate = false;
  final SearchController searchController = SearchController();
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();

  LatLng? userCoordinates;
  List<Placemark> placemarks = [];
  File? selectedImage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserLocation();
    });
  }

  void getUserLocation() async {
    final userPosition = await locationService.askAndGetUserLocation();
    if (userPosition == null) {
      return;
    }

    if (!mounted) return;

    final places = await placemarkFromCoordinates(
      userPosition.latitude!,
      userPosition.longitude!,
    );

    setState(() {
      userCoordinates = LatLng(userPosition.latitude!, userPosition.longitude!);
      placemarks = places;
    });
  }

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
            bottom: 8,
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
        Stack(
          children: [
            InkWell(
              onTap: () async {
                final imagePicker = ImagePicker();

                final file = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                if (file == null) return;

                setState(() {
                  selectedImage = File(file.path);
                });
              },
              child: Container(
                height: 136,
                decoration: BoxDecoration(
                  gradient: selectedImage == null
                      ? LinearGradient(
                          colors: [Color(0xFFCED4FF), Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  image: selectedImage != null
                      ? DecorationImage(
                          image: FileImage(selectedImage!),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withAlpha(100),
                            BlendMode.darken,
                          ),
                        )
                      : null,
                ),
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 32),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      SvgPicture.asset(
                        AssetImages.iconCamera,
                        width: 16,
                        height: 16,
                      ),
                      Text(
                        'Escolher uma foto de capa',
                        style: TextStyle(
                          color: Color(0xFFF3F3F3),
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 94),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  SearchAnchor.bar(
                    searchController: searchController,
                    suggestionsBuilder: (context, controller) {
                      return List.generate(placemarks.length, (index) {
                        final placemark = placemarks.elementAt(index);
                        final text =
                            '${placemark.street}, ${placemark.name}, ${placemark.locality}, ${placemark.country}';
                        return InkWell(
                          onTap: () {
                            controller.closeView(text);
                            controller.text = text;
                          },
                          child: Text(text),
                        );
                      });
                    },
                    isFullScreen: false,
                  ),
                  TextFormField(
                    controller: _tripNameController,
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
                    controller: _resumeController,
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
                  InkWell(
                    onTap: () {
                      ImagePicker().pickMultiImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFFE5E7EA),
                          width: 1.5,
                        ),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 12,
                            children: [
                              SvgPicture.asset(
                                AssetImages.iconPhoto,
                                width: 18,
                                height: 18,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                'Imagens da sua viagem',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF9EA2AE),
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            runSpacing: 6,
                            spacing: 6,
                            children: [
                              if (selectedImage != null)
                                for (var i = 0; i < 10; i++)
                                  SizedBox(
                                    height: 56,
                                    width: 56,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            child: Image.file(
                                              selectedImage!,
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFEE443F),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.17,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                        ],
                      ),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 16,
                    children: [
                      Switch(
                        value: isPrivate,
                        onChanged: (value) {
                          setState(() {
                            isPrivate = value;
                          });
                        },
                      ),
                      Text(
                        'Manter diário privado',
                        style: TextStyle(color: Color(0xFF757575)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        FilledButton(onPressed: () {}, child: Text('Salvar Diário')),
      ],
    ),
  );
}
