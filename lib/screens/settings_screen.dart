// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:thryv/models/diet_model.dart';
import 'package:thryv/models/food_item.dart';
import 'package:thryv/models/steps_model.dart';
import 'package:thryv/models/user_goal_model.dart';
import 'package:thryv/models/user_model.dart';
import 'package:thryv/admin_panel/admin_screen.dart';
import 'package:thryv/models/workout_model.dart';
import 'package:thryv/screens/boarding/splash_screen.dart';
import 'package:thryv/theme/app_colors.dart';
import '../providers/theme_provider.dart'; // adjust path if needed
import 'aboutus.dart';
import 'auth/account_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<bool?> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete your user data?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Cancel
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await Hive.box<UserModel>('userBox').clear();
                  await Hive.box<UserGoalModel>('userGoalBox').clear();
                  await Hive.box<DietPlan>('dietPlans').clear();
                  await Hive.box<WorkoutPlan>('workoutBox').clear();
                  await Hive.box<FoodItem>('foodBox').clear();
                  await Hive.box<StepEntry>('stepsBox').clear();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                    (route) => false,
                  );
                }, // Confirm delete
                child: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.errorRed),
                ),
              ),
            ],
          ),
    );
  }

  late Box<UserModel> userBox;
  late Box<UserGoalModel>? userGoalBox;
  late Box<WorkoutPlan> workoutplan;
  late Box<DietPlan> dietplan;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<UserModel>('userBox');
    workoutplan = Hive.box<WorkoutPlan>('workoutBox');
    dietplan = Hive.box<DietPlan>('dietPlans');
    userGoalBox = Hive.box<UserGoalModel>('userGoalBox'); // get the box here
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // dynamic bg color
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.12),
        child: Container(
          color: theme.primaryColor, // dynamic appbar bg
          padding: EdgeInsets.only(top: height * 0.02, left: width * 0.07),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Text(
                  "Settings",
                  style: GoogleFonts.roboto(
                    fontSize: width * 0.1,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white, // instead of Colors.white
                    // dynamic color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildCard([
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    return SwitchListTile(
                      secondary: Icon(
                        Icons.nightlight_round,
                        color: theme.iconTheme.color,
                      ),
                      title: Text(
                        'Dark mode',
                        style: theme.textTheme.bodyLarge,
                      ),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                    );
                  },
                ),
                // _buildDivider(theme),
                // _buildListTile('Unit Measures', Icons.language, theme),
              ]),
              const SizedBox(height: 24),
              Text(
                'About',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildCard([
                _buildListTile(
                  'About Us',
                  Icons.info_outline,
                  theme,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Aboutus()),
                    );
                  },
                ),
                _buildDivider(theme),
                _buildListTile(
                  'App Version',
                  Icons.device_hub,
                  theme,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Appversion()),
                    );
                  },
                ),
                _buildDivider(theme),
                _buildListTile(
                  'Terms and Conditions',
                  Icons.article,
                  theme,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Liscence()),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 24),
              Text(
                'Account',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildCard([
                _buildListTile(
                  'Account',
                  Icons.person,
                  theme,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountScreen(),
                      ),
                    );
                  },
                ),

                _buildDivider(theme),
                _buildListTile(
                  'Clear Data',
                  Icons.delete,
                  theme,
                  iconColor: AppColors.errorRed,
                  onTap: () async {
                    final confirmed = await _showDeleteConfirmationDialog();
                    if (confirmed == true) {
                      // Restart app state (wipe userGoal or any model variables)
                      setState(() {
                        userGoalBox = null;
                      });

                      // Optional: Restart the whole app screen
                    }
                  },
                ),

                _buildDivider(theme),

                _buildListTile(
                  'Login As Admin',
                  Icons.admin_panel_settings_rounded,
                  theme,
                  iconColor: AppColors.errorRed,

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminScreen()),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 40),
              // Center(
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor:
              //           theme.colorScheme.surface, // dynamic button bg
              //       foregroundColor: Colors.red,
              //       elevation: 4,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       padding: const EdgeInsets.symmetric(
              //         horizontal: 48,
              //         vertical: 16,
              //       ),
              //     ),
              //     onPressed: () {},
              //     child: Text(
              //       'Log Out',
              //       style: theme.textTheme.titleMedium?.copyWith(
              //         fontWeight: FontWeight.bold,
              //         color: Colors.red,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor, // dynamic card bg
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        );
      },
    );
  }

  Widget _buildListTile(
    String title,
    IconData icon,
    ThemeData theme, {
    Color? iconColor,
    VoidCallback? onTap, // Add this line
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? theme.iconTheme.color),
      title: Text(title, style: theme.textTheme.bodyLarge),
      onTap: onTap, // Use the passed onTap
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(height: 1, color: theme.dividerColor);
  }
}
