import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Controllers/task_controller.dart';
import 'package:task_manager/Controllers/theme_controller.dart';
import 'package:task_manager/bloc/task_bloc.dart';
import 'package:task_manager/screens/AddTaskScreen.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/screens/setting_screen.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:task_manager/services/task_service.dart';
import 'package:task_manager/screens/EditTaskScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = ThemeController();
  await themeController.loadTheme();
  await NotificationService.init();
  runApp(MyApp(themeController: themeController));
}


class MyApp extends StatelessWidget{

  final ThemeController themeController;
  const MyApp({required this.themeController});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      BlocProvider(create: (_) => TaskBloc()),
      ChangeNotifierProvider.value(value: themeController)
    ],
      child: const AppRoot(),
    );
  }

}

class AppRoot extends StatelessWidget{
  const AppRoot();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen() ),
    GoRoute(path: '/add', builder: (context, state) => Addtaskscreen()),
    GoRoute(path: '/setting', builder: (context, state) => SettingScreen()),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) => Edittaskscreen(
       id: state.pathParameters['id']!,
      ),
    )
  ]
);