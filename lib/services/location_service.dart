import 'dart:developer';

import 'package:location/location.dart';

class LocationService {
  final Location location = Location();

  Future<LocationData?> askAndGetUserLocation() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return null;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return null;
        }
      }

      await location.changeSettings(accuracy: LocationAccuracy.balanced, interval: 1000);

      final userPosition = await location.getLocation();
      if (userPosition.latitude == null || userPosition.longitude == null) {
        return null;
      }

      return userPosition;
    } catch (e) {
      log("Error getting user location", error: e);
      return null;
    }
  }
}
