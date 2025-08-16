import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/diary/models/diary_form_result.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
import 'package:rumo/features/diary/models/place.dart';
import 'package:rumo/features/diary/repositories/file_repository.dart';
import 'package:rumo/features/diary/repositories/place_repository.dart';
import 'package:rumo/features/diary/widgets/create_diary_bottom_sheet/create_diary_state.dart';
import 'package:rumo/features/diary/widgets/star_rating.dart';

class DiaryForm extends StatefulWidget {
  final DiaryModel? diary;
  final String buttonTitle;
  final Future<void> Function(DiaryFormResult result) onSubmit;
  final void Function(String? message)? onError;
  const DiaryForm({
    required this.buttonTitle,
    required this.onSubmit,
    this.diary,
    this.onError,
    super.key,
  });

  @override
  State<DiaryForm> createState() => _DiaryFormState();
}

class _DiaryFormState extends State<DiaryForm> {
  final placeRepository = PlaceRepository();
  final fileRepository = FileRepository();

  final SearchController locationSearchController = SearchController();
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPrivate = false;
  File? selectedImage;
  List<File> tripImages = [];
  double rating = 0;
  Place? selectedPlace;

  String? lastQuery;

  bool isLoading = false;

  Timer? _debounce;

  ValueNotifier<CreateDiaryState> createDiaryState =
      ValueNotifier<CreateDiaryState>(CreateDiaryInitial());

  @override
  void initState() {
    if (widget.diary != null) {
      locationSearchController.text = widget.diary!.location;
      _tripNameController.text = widget.diary!.name;
      _resumeController.text = widget.diary!.resume;

      isPrivate = widget.diary!.isPrivate;
      rating = widget.diary!.rating;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.wait([
          fileRepository.downloadImage(widget.diary!.coverImage).then((file) {
            selectedImage = file;
          }),
          Future.wait(
            widget.diary!.images.map((imageUrl) async {
              return fileRepository.downloadImage(imageUrl);
            }),
          ).then((tripImagesFiles) {
            final nonNullTripImages = tripImagesFiles
                .whereType<File>()
                .toList();
            tripImages = nonNullTripImages;
          }),
        ]);

        if (mounted) {
          setState(() {});
        }
      });
    }

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
      try {
        createDiaryState.value = CreateDiaryLoading();
        final remotePlaces = await placeRepository.getPlaces(query: query);
        if (!mounted) return;
        createDiaryState.value = CreateDiarySuccess(places: remotePlaces);
      } catch (error, stackTrace) {
        log("Error fetching places", error: error, stackTrace: stackTrace);
        createDiaryState.value = CreateDiaryError(
          message: "Não foi possível encontrar locais",
        );
      }
    });
  }

  void closeAndOpenLocationSearch(String? query) {
    if (!locationSearchController.isOpen) {
      locationSearchController.openView();
    } else {
      locationSearchController.closeView(query);
      locationSearchController.openView();
    }
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Stack(
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
                        if (widget.diary == null && selectedPlace == null) {
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
                                return ValueListenableBuilder(
                                  valueListenable: createDiaryState,
                                  builder: (context, state, _) {
                                    return switch (state) {
                                      CreateDiaryError error => Center(
                                        child: Text(error.message),
                                      ),
                                      CreateDiaryLoading _ => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      CreateDiarySuccess success =>
                                        ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: success.places.length,
                                          itemBuilder: (context, index) {
                                            final place = success.places
                                                .elementAt(index);
                                            final formattedLocation =
                                                place.formattedLocation;

                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  locationSearchController
                                                      .closeView(
                                                        formattedLocation,
                                                      );
                                                  selectedPlace = place;
                                                  lastQuery = formattedLocation;
                                                  _debounce?.cancel();
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                child: Text(
                                                  formattedLocation,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color(0xFF131927),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      _ => SizedBox.shrink(),
                                    };
                                  },
                                );
                              },
                              suggestionsBuilder: (context, controller) {
                                return [];
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
                            initialRating: rating,                    
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

                if (widget.diary == null && selectedPlace == null) {
                  widget.onError?.call("Por favor, selecione um local");
                  return;
                }

                if (selectedImage == null) {
                  widget.onError?.call(
                    "Por favor, selecione uma imagem de capa",
                  );
                  return;
                }

                final ownerId = FirebaseAuth.instance.currentUser?.uid;
                if (ownerId == null) {
                  widget.onError?.call("Usuário não autenticado");
                  return;
                }
                setState(() {
                  isLoading = true;
                });

                await widget.onSubmit(
                  DiaryFormResult(
                    selectedImage: selectedImage!,
                    tripImages: tripImages,
                    ownerId: ownerId,
                    selectedPlace: selectedPlace,
                    name: _tripNameController.text,
                    resume: _resumeController.text,
                    rating: rating,
                    isPrivate: isPrivate,
                    latitude: selectedPlace?.latitude,
                    longitude: selectedPlace?.longitude,
                  ),
                );
              } catch (error, stackTrace) {
                log(
                  "Error on diary form",
                  error: error,
                  stackTrace: stackTrace,
                );
                widget.onError?.call(null);
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
                return Text(widget.buttonTitle);
              },
            ),
          ),
        ),
      ],
    );
  }
}
