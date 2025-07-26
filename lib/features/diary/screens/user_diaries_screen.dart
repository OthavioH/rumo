import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class UserDiariesScreen extends StatefulWidget {
  const UserDiariesScreen({super.key});

  @override
  State<UserDiariesScreen> createState() => _UserDiariesScreenState();
}

class _UserDiariesScreenState extends State<UserDiariesScreen> {
  final location = Location();
  final MapController mapController = MapController();

  bool isMapReady = false;

  String get mapKey => dotenv.env["MAPTILE_KEY"] ?? "";

  LatLng? userCooordinates;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserLocation();
    });
  }

  void getUserLocation() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      await location.changeSettings(accuracy: LocationAccuracy.balanced);

      final userPosition = await location.getLocation();
      if (userPosition.latitude == null || userPosition.longitude == null) {
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
    } catch (e) {
      log("Error getting user location", error: e);
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
        ],
      ),
    );
  }
}
