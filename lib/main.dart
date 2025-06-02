import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thryv/helpers/hive_setup_registration.dart';
import 'package:thryv/screens/home/home_screen.dart';
import 'package:thryv/screens/home/navigation_screen.dart';
import 'package:thryv/theme/app_colors.dart';
import 'package:thryv/screens/boarding/splash_screen.dart';
import 'package:thryv/providers/theme_provider.dart';
import 'package:hive/hive.dart';
import 'package:thryv/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();

  final userBox = Hive.box<UserModel>('userBox');
  final bool hasUserData = userBox.get('user') != null;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),

      child: AppInitializer(hasUserData: hasUserData),
    ),
  );
}

class AppInitializer extends StatelessWidget {
  final bool hasUserData;

  const AppInitializer({super.key, required this.hasUserData});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'thryv',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.currentTheme,
          theme: ThemeData(
            brightness: Brightness.light,
            highlightColor: AppColors.white,
            primaryColor: AppColors.primary,
            primaryColorLight: AppColors.accent,
            scaffoldBackgroundColor: AppColors.backgroundLight,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            highlightColor: AppColors.white,
            primaryColor: AppColors.primary,
            primaryColorLight: AppColors.accent,
            scaffoldBackgroundColor: AppColors.backgroundDark,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),

          home: hasUserData ? const NavigationScreen() : const SplashScreen(),
        );
      },
    );
  }
}
