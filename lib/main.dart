import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thryv/models/user_goal_model.dart';
import 'models/user_model.dart';
import 'models/food_item.dart';
import 'screens/boarding/splash_screen.dart';
import 'providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:thryv/models/steps_model.dart';
import 'models/workout_model.dart';
import 'package:thryv/models/diet_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('userBox');

  Hive.registerAdapter(WorkoutPlanAdapter());
  Hive.registerAdapter(DietPlanAdapter());

  Hive.registerAdapter(UserGoalModelAdapter());
  await Hive.openBox<UserGoalModel>('userGoalBox');

  Hive.registerAdapter(FoodItemAdapter());
  await Hive.openBox<FoodItem>('foodBox');

  Hive.registerAdapter(StepEntryAdapter());
  await Hive.openBox<StepEntry>('stepsBox');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:
          Colors.transparent, // Optional: transparent or match your app bar
      statusBarIconBrightness: Brightness.light, // For Android
      statusBarBrightness: Brightness.dark, // For iOS
    ),
  );

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
          title: 'thryv',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.currentTheme,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF020770),
            primaryColorLight: const Color.fromARGB(255, 85, 94, 255),
            scaffoldBackgroundColor: const Color.fromARGB(255, 243, 243, 255),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF020770),
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
