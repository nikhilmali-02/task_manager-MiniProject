import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Controllers/theme_controller.dart';

class SettingScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final _isDarkMode = context.watch<ThemeController>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(onPressed: () => context.pop(), icon: Icon(Icons.arrow_back)),
      ),
      body: SwitchListTile(
        title: Text('Dark Mode'),
          value: _isDarkMode,
          onChanged: (_) => context.read<ThemeController>().toggleTheme()
      )
    );
  }
}