import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Controllers/task_controller.dart';
import 'package:task_manager/screens/AddTaskScreen.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/services/task_service.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskController(TaskService()),
      child: MaterialApp.router(
      routerConfig: router,
    ),
    );
  }

}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen() ),
    GoRoute(path: '/add', builder: (context, state) => Addtaskscreen()),
    ]
);