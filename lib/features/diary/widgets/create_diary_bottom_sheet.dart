import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/diary/models/create_diary_model.dart';
import 'package:rumo/features/diary/models/place.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';
import 'package:rumo/features/diary/repositories/place_repository.dart';
import 'package:rumo/features/diary/widgets/star_rating.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CreateDiaryBottomSheet extends StatefulWidget {
  const CreateDiaryBottomSheet({super.key});

  @override
  State<CreateDiaryBottomSheet> createState() => _CreateDiaryBottomSheetState();
}

class _CreateDiaryBottomSheetState extends State<CreateDiaryBottomSheet> {
  final placeRepository = PlaceRepository();

  final SearchController locationSearchController = SearchController();
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPrivate = false;
  File? selectedImage;
  List<File> tripImages = [];
  double rating = 0;
  List<Place> places = [];
  Place? selectedPlace;

  String? lastQuery;

  bool isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    locationSearchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    locationSearchController.removeListener(_onSearchChanged);
    locationSearchController.dispose();
    _tripNameController.dispose();
    _resumeController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = locationSearchController.text;

    if (query == lastQuery) return;

    setState(() {
      lastQuery = query;
    });

    _debounce?.cancel();

    if (query.trim().isEmpty) return;

    _debounce = Timer(Duration(seconds: 1, milliseconds: 500), () async {
      final remotePlaces = await placeRepository.getPlaces(query: query);
      if (!mounted) return;
      setState(() {
        places = remotePlaces;
      });

      if (!locationSearchController.isOpen) {
        locationSearchController.openView();
      } else {
        locationSearchController.closeView(query);
        locationSearchController.openView();
      }
    });
  }

  void showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Diário criado com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void showError(String message) {
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
    alignLabelWithHint: true,
    prefixIconConstraints: BoxConstraints(maxWidth: 48),
    hintText: hintText,
  );

  @override
  Widget build(BuildContext context) => Form(
    key: _formKey,
    child: Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
                    FormField(
                      validator: (_) {
                        if (selectedPlace == null) {
                          return 'Por favor, selecione um local';
                        }

                        return null;
                      },
                      builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SearchAnchor.bar(
                              searchController: locationSearchController,
                              barLeading: SvgPicture.asset(
                                AssetImages.iconLocationPin,
                                width: 24,
                                height: 24,
                              ),
                              viewLeading: SvgPicture.asset(
                                AssetImages.iconLocationPin,
                                width: 24,
                                height: 24,
                              ),
                              barSide: WidgetStateProperty.resolveWith((_) {
                                if (formState.hasError) {
                                  return BorderSide(
                                    color: Color(0xFFEE443F),
                                    width: 1.5,
                                  );
                                }

                                return BorderSide(
                                  color: Color(0xFFE5E7EA),
                                  width: 1.5,
                                );
                              }),
                              barHintText: 'Localização',
                              barPadding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              viewBuilder: (suggestions) {
                                return ListView(
                                  padding: EdgeInsets.zero,
                                  children: suggestions.toList(),
                                );
                              },
                              suggestionsBuilder: (context, controller) {
                                return List.generate(places.length, (index) {
                                  final place = places.elementAt(index);
                                  final formattedLocation =
                                      place.formattedLocation;

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        controller.closeView(formattedLocation);
                                        selectedPlace = place;
                                        lastQuery = formattedLocation;
                                        _debounce?.cancel();
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        formattedLocation,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF131927),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              },
                              isFullScreen: false,
                            ),
                            if (formState.hasError) const SizedBox(height: 4),
                            if (formState.hasError &&
                                formState.errorText != null)
                              Text(
                                formState.errorText!,
                                style: TextStyle(color: Color(0xFFEE443F)),
                              ),
                          ],
                        );
                      },
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, insira o nome da viagem';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _resumeController,
                      minLines: 4,
                      maxLines: 4,
                      decoration: iconTextFieldDecoration(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 70),
                          child: SvgPicture.asset(
                            AssetImages.iconThreeLines,
                            width: 16,
                            height: 16,
                            fit: BoxFit.cover,
                          ),
                        ),
                        hintText: 'Resumo da sua viagem',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, insira um breve resumo da sua viagem';
                        }
                        return null;
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        final pickedFiles = await ImagePicker()
                            .pickMultiImage();
                        if (pickedFiles.isEmpty) return;

                        setState(() {
                          tripImages = pickedFiles
                              .map((file) => File(file.path))
                              .toList();
                        });
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 17.5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            Builder(
                              builder: (context) {
                                if (tripImages.isEmpty) {
                                  return SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    runSpacing: 6,
                                    spacing: 6,
                                    children: tripImages.map<Widget>((image) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            tripImages.remove(image);
                                          });
                                        },
                                        child: SizedBox(
                                          height: 56,
                                          width: 56,
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  child: Image.file(
                                                    image,
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
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Nota para a viagem'),
                          const SizedBox(height: 16),
                          StarRating(
                            onRatingChanged: (newRating) {
                              setState(() {
                                rating = newRating;
                              });
                            },
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FilledButton(
              onPressed: () async {
                try {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  if (selectedPlace == null) {
                    showError("Por favor, selecione um local");
                    return;
                  }

                  if (selectedImage == null) {
                    showError("Por favor, selecione uma imagem de capa");
                    return;
                  }

                  final ownerId = FirebaseAuth.instance.currentUser?.uid;
                  if (ownerId == null) {
                    showError("Usuário não autenticado");
                    return;
                  }
                  setState(() {
                    isLoading = true;
                  });

                  final coverUrl = await uploadImage(selectedImage!);

                  final tripImagesUploads = tripImages.map((image) {
                    return uploadImage(image);
                  });

                  final tripImagesUrls = await Future.wait(tripImagesUploads);

                  final diary = CreateDiaryModel(
                    ownerId: ownerId,
                    location: selectedPlace!.formattedLocation,
                    name: _tripNameController.text,
                    coverImage: coverUrl,
                    resume: _resumeController.text,
                    images: tripImagesUrls,
                    rating: rating,
                    isPrivate: isPrivate,
                    latitude: selectedPlace!.latitude,
                    longitude: selectedPlace!.longitude,
                  );

                  await DiaryRepository().createDiary(diary: diary);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    showSuccess();
                  }
                } catch (error, stackTrace) {
                  log(
                    "Error creating diary",
                    error: error,
                    stackTrace: stackTrace,
                  );
                  showError("Erro ao criar diário");
                } finally {
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
              child: Builder(
                builder: (context) {
                  if (isLoading) {
                    return SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3.5,
                      ),
                    );
                  }
                  return Text('Salvar Diário');
                },
              ),
            ),
          ),
        ],
      ),
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
