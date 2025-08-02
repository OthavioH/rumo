import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';
import 'package:rumo/features/diary/widgets/diary_map_marker.dart';
import 'package:rumo/services/location_service.dart';

class UserDiariesScreen extends StatefulWidget {
  const UserDiariesScreen({super.key});

  @override
  State<UserDiariesScreen> createState() => _UserDiariesScreenState();
}

class _UserDiariesScreenState extends State<UserDiariesScreen> {
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

      final user = AuthRepository().getCurrentUser();

      if (user == null) return;

      final userId = user.uid;
      final diaries = await DiaryRepository().getUserDiaries(userId: userId);
      log(diaries.length.toString());
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
    if (isMapReady) {
      mapController.move(userCooordinates!, 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          if (userCooordinates != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: userCooordinates!,
                  width: 80,
                  height: 80,
                  child: DiaryMapMarker(
                    imageUrl:
                        'https://gkzpoliqyqvcqamnntow.supabase.co/storage/v1/object/public/images//677f805d-1e2c-4e05-ac61-17221ac02cfc.jpg',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
