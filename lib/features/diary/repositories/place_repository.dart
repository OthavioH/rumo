import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rumo/core/helpers/app_environment.dart';
import 'package:rumo/features/diary/models/place.dart';

class PlaceRepository {
  late final Dio client;

  PlaceRepository() {
    client = Dio(
      BaseOptions(
        baseUrl: 'https://nominatim.openstreetmap.org',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'RumoApp - ${AppEnvironment.placesAPIAgentName}',
          'Accept-Language': 'pt-BR',
        },
      ),
    );
  }

  Future<List<Place>> getPlaces({required String query}) async {
    try {
      final response = await client.get('/search', queryParameters: {
        'q': query,
        'format': 'json',
        'addressdetails': 1,
        'limit': 10,
      });

      return Place.fromJsonList(response.data);
    } catch (error, stackTrace) {
      log("Error fetching places", error: error, stackTrace: stackTrace);
      return [];
    }
  }
}
