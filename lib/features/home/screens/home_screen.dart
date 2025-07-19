import 'package:flutter/material.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/home/widgets/bottom_nav_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    bottomNavigationBar: BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BottomNavItem(icon: AssetImages.iconMap, label: 'Mapa'),
          BottomNavItem(icon: AssetImages.iconMap, label: 'Diários'),
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: Color(0xFFDDE1FF)),
            onPressed: () {},
            icon: Icon(Icons.add, color: Color(0xFF4E61F6), size: 20),
          ),
          BottomNavItem(icon: AssetImages.iconMap, label: 'Explorar'),
          BottomNavItem(icon: AssetImages.iconMap, label: 'Perfil'),
        ],
      ),
    ),
    body: Builder(
      builder: (context) {
        return switch (currentIndex) {
          1 => Center(child: Text('Diários')),
          _ => Scaffold(
            appBar: AppBar(title: Text('AppBar Mapa')),
            body: Center(child: Text('Mapa')),
          ),
        };
      },
    ),
  );
}


