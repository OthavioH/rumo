import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
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

  List<DiaryModel> diaries = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getUserLocation();

      final user = AuthRepository().getCurrentUser();

      if (user == null) return;

      final userId = user.uid;

      final fetchedDiaries = await DiaryRepository().getUserDiaries(
        userId: userId,
      );
      if (mounted) {
        setState(() {
          diaries = fetchedDiaries;
        });
        if (diaries.isEmpty) return;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.3,
        minChildSize: 0.3,
        builder: (context, controller) {
          return ListView.builder(
            controller: controller,
            itemCount: 40,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Diary $index'),
              );
            },
          );
        },
      ),
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
          ),
        ],
      ),
    );
  }
}
