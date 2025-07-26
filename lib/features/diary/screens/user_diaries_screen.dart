import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UserDiariesScreen extends StatefulWidget {
  const UserDiariesScreen({super.key});

  @override
  State<UserDiariesScreen> createState() => _UserDiariesScreenState();
}

class _UserDiariesScreenState extends State<UserDiariesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(0,0)
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'br.com.othavioh.rumo',
          ),
        ],
      ),
    );
  }
}
