import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumo/features/diary/controllers/user_diary_controller.dart';
import 'package:rumo/features/diary/screens/user_diaries_list_view/user_diaries_list_view.dart';
import 'package:rumo/features/diary/widgets/diary_map_marker.dart';
import 'package:rumo/services/location_service.dart';

class UserDiariesScreen extends ConsumerStatefulWidget {
  const UserDiariesScreen({super.key});

  @override
  ConsumerState<UserDiariesScreen> createState() => _UserDiariesScreenState();
}

class _UserDiariesScreenState extends ConsumerState<UserDiariesScreen> {
  final MapController mapController = MapController();
  final locationService = LocationService();

  bool isMapReady = false;

  String get mapKey => dotenv.env["MAPTILE_KEY"] ?? "";

  LatLng? userCooordinates;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getUserLocation();
    });
  }

  void getUserLocation() async {
    final userPosition = await locationService.askAndGetUserLocation();
    if (userPosition == null) {
      return;
    }

    setState(() {
      userCooordinates = LatLng(
        userPosition.latitude!,
        userPosition.longitude!,
      );
    });

    final state = ref.watch(userDiaryControllerProvider);
    final diaries = state.valueOrNull ?? [];
    if (diaries.isEmpty && isMapReady) {
      mapController.move(userCooordinates!, 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userDiaryControllerProvider, (_, nextState) async {
      if (nextState.valueOrNull != null) {
        final diaries = [];

        if (diaries.isEmpty) {
          while (!isMapReady) {
            await Future.delayed(Duration(seconds: 1));
          }

          if (userCooordinates == null) {
            getUserLocation();
            return;
          }

          mapController.move(userCooordinates!, 15);
          return;
        }

        final diariesCoordinates = diaries
            .map<LatLng>((diary) => LatLng(diary.latitude, diary.longitude))
            .toList();

        if (isMapReady) {
          mapController.fitCamera(
            CameraFit.coordinates(
              coordinates: diariesCoordinates,
              minZoom: 12,
              maxZoom: 18,
            ),
          );
        }
      }
    });
    final currentTheme = Theme.of(context);
    return SafeArea(
      child: Theme(
        data: currentTheme.copyWith(
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent
          ),
        ),
        child: Scaffold(
          bottomSheet: UserDiariesListView(),
          body: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: userCooordinates ?? LatLng(0, 0),
              onMapReady: () {
                setState(() {
                  isMapReady = true;
                });
                getUserLocation();
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$mapKey',
                userAgentPackageName: 'br.com.othavioh.rumo',
              ),
              Builder(
                builder: (context) {
                  final state = ref.watch(userDiaryControllerProvider);
                  return state.when(
                    error: (error, stackTrace) {
                      log(
                        "Error fetching user diaries",
                        error: error,
                        stackTrace: stackTrace,
                      );
                      return SizedBox.shrink();
                    },
                    loading: () => Center(child: CircularProgressIndicator()),
                    data: (diaries) {
                      if (diaries.isEmpty) return SizedBox.shrink();

                      List<Marker> markers = diaries.map<Marker>((diary) {
                        return Marker(
                          point: LatLng(diary.latitude, diary.longitude),
                          width: 80,
                          height: 80,
                          child: DiaryMapMarker(imageUrl: diary.coverImage),
                        );
                      }).toList();

                      return MarkerLayer(markers: markers);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
