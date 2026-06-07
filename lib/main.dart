import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Controllers/theme_controller.dart';
import 'package:task_manager/bloc/task_bloc.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/screens/AddTaskScreen.dart';
import 'package:task_manager/screens/LoginScreen.dart';
import 'package:task_manager/screens/SignupScreen.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/screens/setting_screen.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:task_manager/screens/EditTaskScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = ThemeController();
  await themeController.loadTheme();
  await NotificationService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(themeController: themeController));
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;
  const MyApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => TaskBloc()),
        ChangeNotifierProvider.value(value: themeController),
      ],
      child: const AppRoot(),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

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
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;
    final isOnAuthRoute =
        state.matchedLocation == '/login' || state.matchedLocation == '/signup';

    if (!isLoggedIn && !isOnAuthRoute) return '/login';
    if (isLoggedIn && isOnAuthRoute) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/add', builder: (context, state) => AddTaskScreen()),
    GoRoute(path: '/setting', builder: (context, state) => SettingScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) =>
          EditTaskScreen(id: state.pathParameters['id']!),
    ),
  ],
);
