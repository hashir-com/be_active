// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart'; // adjust path if needed
import 'admin_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                    color: Colors.white, // dynamic color
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
                _buildDivider(theme),
                _buildListTile('Unit Measures', Icons.language, theme),
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
                _buildListTile('About Us', Icons.info_outline, theme),
                _buildDivider(theme),
                _buildListTile('App Version', Icons.device_hub, theme),
                _buildDivider(theme),
                _buildListTile('License', Icons.article, theme),
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
                _buildListTile('Account', Icons.person, theme),
                _buildDivider(theme),
                _buildListTile(
                  'Delete',
                  Icons.delete,
                  theme,
                  iconColor: Colors.red,
                ),
                _buildDivider(theme),
                _buildListTile(
                  'Login As Admin',
                  Icons.admin_panel_settings_rounded,
                  theme,
                  iconColor: Colors.red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminScreen()),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        theme.colorScheme.surface, // dynamic button bg
                    foregroundColor: Colors.red,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Log Out',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
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
                color: Colors.black12,
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
