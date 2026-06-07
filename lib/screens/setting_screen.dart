import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Controllers/theme_controller.dart';
import 'package:task_manager/services/auth_service.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeController>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Dark Mode'),
              value: isDarkMode,
              onChanged: (_) => context.read<ThemeController>().toggleTheme(),
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut();
                context.go('/login');
              },
              child: Text('SignOut'),
            ),
          ],
        ),
      ),
    );
  }
}
