import 'package:flutter/material.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/home/widgets/bottom_nav_item.dart';
import 'package:rumo/features/user/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void onSelectItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFF3F3F3), width: 1)),
        ),
        child: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BottomNavItem(
                icon: AssetImages.iconMap,
                label: 'Mapa',
                currentSelectedIndex: currentIndex,
                index: 0,
                onSelectItem: onSelectItem,
              ),
              BottomNavItem(
                icon: AssetImages.iconDiaries,
                label: 'Diários',
                currentSelectedIndex: currentIndex,
                index: 1,
                onSelectItem: onSelectItem,
              ),
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Color(0xFFDDE1FF),
                ),
                onPressed: () {},
                iconSize: 28,
                icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
              ),
              BottomNavItem(
                icon: AssetImages.iconExplore,
                label: 'Explorar',
                currentSelectedIndex: currentIndex,
                index: 2,
                onSelectItem: onSelectItem,
              ),
              BottomNavItem(
                icon: AssetImages.iconProfile,
                label: 'Perfil',
                currentSelectedIndex: currentIndex,
                index: 3,
                onSelectItem: onSelectItem,
              ),
            ],
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          return switch (currentIndex) {
            1 => Center(child: Text('Diários')),
            2 => Center(child: Text('Explorar')),
            3 => ProfileScreen(),
            _ => Scaffold(
              appBar: AppBar(title: Text('AppBar Mapa')),
              body: Center(child: Text('Mapa')),
            ),
          };
        },
      ),
    );
  }
}
