import 'package:flutter/material.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/diary/screens/user_diaries_screen.dart';
import 'package:rumo/features/diary/widgets/user_stats_bottom_sheet.dart';
import 'package:rumo/features/home/widgets/bottom_nav_item.dart';
import 'package:rumo/features/user/screens/profile_screen.dart';
import 'package:rumo/features/diary/widgets/create_diary_bottom_sheet/create_diary_bottom_sheet.dart';

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
                style: IconButton.styleFrom(backgroundColor: Color(0xFFDDE1FF)),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.9,
                    ),
                    builder: (context) => CreateDiaryBottomSheet(),
                  );
                },
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
            1 => UserDiariesScreen(),
            2 => Center(child: Text('Explorar')),
            3 => ProfileScreen(),
            _ => SafeArea(
              child: Scaffold(
                body: Center(child: Text('Mapa')),
                backgroundColor: Color(0xFF4E61F6),
                bottomSheet: UserStatsBottomSheet(),
              ),
            ),
          };
        },
      ),
    );
  }
}
