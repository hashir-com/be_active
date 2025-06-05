import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thryv/services/hive_service.dart';
import 'package:thryv/models/user_model.dart';
import '../explore screen/explore_screen.dart';
import '../settings_screen.dart';
import '../progress_screen.dart';
import 'home_screen.dart';
import '../tracking/tracking_screen.dart'; // For the modal function showTrackOptions()

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
    SizedBox.shrink(), // Placeholder for track (not a real screen)
    HeatMapChart(year: 2025, month: 5),

    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: _screens[_currentIndex],

      // ❗ Hide bottom nav when tracking (index == 2)
      bottomNavigationBar:
          _currentIndex == 2
              ? null
              : _buildBottomNavBar(width, height, context),
    );
  }

  Widget _buildBottomNavBar(double width, double height, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final primaryColorLight = Theme.of(context).primaryColorLight;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final iconColor = isDark ? Colors.white : Colors.black;

    final theme = Theme.of(context);
    final Color activeColor =
        theme.brightness == Brightness.dark ? primaryColorLight : primaryColor;

    List<Widget> icons = [
      SvgPicture.asset(
        'assets/home.svg',
        // ignore: deprecated_member_use
        color: _currentIndex == 0 ? activeColor : iconColor,
      ),
      Image.asset(
        'assets/explore.png',
        width: 30,
        height: 30,
        color: _currentIndex == 1 ? activeColor : iconColor,
      ),
      SvgPicture.asset(
        'assets/plus.svg',
        // ignore: deprecated_member_use
        color: _currentIndex == 2 ? activeColor : iconColor,
      ),
      Image.asset(
        'assets/progress.png',
        width: 30,
        height: 30,
        color: _currentIndex == 3 ? activeColor : iconColor,
      ),
      SvgPicture.asset(
        'assets/settings.svg',
        // ignore: deprecated_member_use
        color: _currentIndex == 4 ? activeColor : iconColor,
      ),
    ];

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.04),
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        height: 65,
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? const Color.fromARGB(50, 196, 189, 255)
                      : Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 14),
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
        if (index == 2) {
          // Show modal instead of changing index
          showTrackOptions(context);
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration:
            isActive
                ? BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(0, 255, 255, 255),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(31, 169, 169, 169),
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
