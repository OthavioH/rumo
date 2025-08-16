import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumo/core/helpers/app_environment.dart';
import 'package:rumo/features/diary/screens/community_diaries_map/community_diaries_map_controller.dart';
import 'package:rumo/features/diary/screens/user_diaries_list_view/widgets/user_info_chip/user_info_chip.dart';
import 'package:rumo/features/diary/screens/user_diaries_list_view/widgets/user_info_chip/user_info_notifier.dart';
import 'package:rumo/features/diary/widgets/diary_map_marker.dart';
import 'package:rumo/features/diary/widgets/user_stats_bottom_sheet.dart';
import 'package:rumo/services/location_service.dart';

class CommunityDiariesMapScreen extends ConsumerStatefulWidget {
  const CommunityDiariesMapScreen({super.key});

  @override
  ConsumerState<CommunityDiariesMapScreen> createState() => _CommunityDiariesMapScreenState();
}

class _CommunityDiariesMapScreenState extends ConsumerState<CommunityDiariesMapScreen> {
  final MapController mapController = MapController();
  final locationService = LocationService();

  bool isMapReady = false;

  LatLng? userCooordinates;

  void getUserLocation() async {
    final userPosition = await locationService.askAndGetUserLocation();
    if (userPosition == null) {
      return;
    }

    if (!mounted) return;

    setState(() {
      userCooordinates = LatLng(
        userPosition.latitude!,
        userPosition.longitude!,
      );
    });

    final state = ref.watch(communityDiariesMapControllerProvider);
    final diaries = state.valueOrNull ?? [];
    if (diaries.isEmpty && isMapReady) {
      mapController.move(userCooordinates!, 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(communityDiariesMapControllerProvider, (_, nextState) async {
      if (nextState.valueOrNull != null) {
        final diaries = nextState.valueOrNull!;

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

        final diariesCoordinates = diaries.map<LatLng>((diary) => LatLng(diary.latitude, diary.longitude)).toList();

        if (isMapReady) {
          mapController.fitCamera(
            CameraFit.coordinates(
              coordinates: diariesCoordinates,
              minZoom: 1,
              maxZoom: 18,
              padding: EdgeInsets.all(50),
            ),
          );
        }
      }
    });
    return Scaffold(
      bottomSheet: UserStatsBottomSheet(),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          child: FlutterMap(
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
                urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=${AppEnvironment.mapTileKey}',
                userAgentPackageName: 'br.com.othavioh.rumo',
              ),
              Consumer(
                builder: (context, ref, _) {
                  final user = ref.watch(userInfoProvider).valueOrNull;
                  final state = ref.watch(communityDiariesMapControllerProvider);
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
                          child: DiaryMapMarker(
                            imageUrl: diary.coverImage,
                            isFromLoggedUser: diary.ownerId == user?.uid,
                          ),
                        );
                      }).toList();

                      return MarkerLayer(markers: markers);
                    },
                  );
                },
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: UserInfoChip(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
