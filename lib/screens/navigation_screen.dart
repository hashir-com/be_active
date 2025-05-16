import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:be_active/services/hive_service.dart';
import 'package:be_active/models/user_model.dart';
import 'explore_screen.dart';
import 'settings_screen.dart';
import 'progress_screen.dart';
import 'home_screen.dart';
import 'tracking_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreen();
}

class _NavigationScreen extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    TrackingScreen(),
    ProgressScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(width, height),
    );
  }

  Widget _buildBottomNavBar(double width, double height) {
    List<Widget> icons = [
      SvgPicture.asset('assets/home.svg'),
      Image.asset(
        'assets/explore.png',
        width: 30,
        height: 30,
        fit: BoxFit.contain,
      ),
      SvgPicture.asset('assets/plus.svg'),
      Image.asset(
        'assets/progress.png',
        width: 30,
        height: 30,
        fit: BoxFit.contain,
      ),
      SvgPicture.asset('assets/settings.svg'),
    ];

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.030,
      ),
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      height: 65,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF040B90)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(icons.length, (index) {
          return _buildNavIcon(
            icons[index],
            isActive: _currentIndex == index,
            index: index,
          );
        }),
      ),
    );
  }

  Widget _buildNavIcon(
    Widget icon, {
    required bool isActive,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration:
            isActive
                ? BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                )
                : null,
        child: Transform.scale(scale: isActive ? 1.3 : 1.0, child: icon),
      ),
    );
  }
}
