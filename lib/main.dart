import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user_model.dart';
import 'models/food_item.dart';
import 'screens/splash_screen.dart';
import 'providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('userBox');

  Hive.registerAdapter(FoodItemAdapter());
  await Hive.openBox<FoodItem>('foodBox');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const AppInitializer(),
    ),
  );
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Be Active',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.currentTheme,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF040B90),
            primaryColorLight: const Color.fromARGB(255, 85, 94, 255),
            scaffoldBackgroundColor: const Color.fromARGB(255, 243, 243, 255),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF040B90),
            primaryColorLight: const Color.fromARGB(255, 85, 94, 255),
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              foregroundColor: Colors.white,
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
