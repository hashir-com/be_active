import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HelperScreen extends StatelessWidget {
  const HelperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final padding = EdgeInsets.symmetric(
      horizontal: isDesktop ? 20.w : 16.w,
      vertical: isDesktop ? 14.h : 12.h,
    );

    final sections = [
      {
        'title': '1. Getting Started',
        'description':
            'Create your account by entering personal details and setting health goals. This helps personalize your experience.',
        'icon': Icons.person_outline,
      },
      {
        'title': '2. Track Meals',
        'description':
            'Log what you eat throughout the day. Calories are automatically calculated and compared to your daily goal.',
        'icon': Icons.local_dining_outlined,
      },
      {
        'title': '3. Water Intake',
        'description':
            'Tap to add glasses of water you drink. Stay hydrated and track daily progress easily.',
        'icon': Icons.water_drop_outlined,
      },
      {
        'title': '4. Sleep Tracker',
        'description':
            'Add sleep duration each night and set sleep goals to improve rest quality.',
        'icon': Icons.bedtime_outlined,
      },
      {
        'title': '5. Steps & Activity',
        'description':
            'Track your daily steps. The app shows calories burned and goal progress with a graph.',
        'icon': Icons.directions_walk,
      },
      {
        'title': '6. Progress Heatmap',
        'description':
            'Visualize your progress using a heatmap. Tap on a day to view completed activities.',
        'icon': Icons.calendar_month_outlined,
      },
      {
        'title': '7. Explore Plans',
        'description':
            'Discover workout and diet plans curated by experts. Admins regularly update content.',
        'icon': Icons.explore_outlined,
      },
      {
        'title': '8. Profile & Settings',
        'description':
            'Edit your personal info, change goals, and switch between dark/light mode from the account screen.',
        'icon': Icons.settings_outlined,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'How to Use the App',
          style: GoogleFonts.roboto(
            fontSize: isDesktop ? 12.sp : 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: padding,
        child: ListView.builder(
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            return Padding(
              padding: EdgeInsets.only(bottom: isDesktop ? 6.h : 10.h),
              child: Card(
                elevation: isDesktop ? 4 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isDesktop ? 20.r : 14.r),
                ),
                child: ExpansionTile(
                  leading: Icon(
                    section['icon'] as IconData,
                    color: theme.primaryColorDark,
                    size: isDesktop ? 10.sp : 26.sp,
                  ),
                  title: Text(
                    section['title']!.toString(),
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontSize: isDesktop ? 5.sp : 16.sp,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 14.w : 16.w,
                        vertical: isDesktop ? 8.h : 8.h,
                      ),
                      child: Text(
                        section['description']!.toString(),
                        style: GoogleFonts.roboto(
                          fontSize: isDesktop ? 5.sp : 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
