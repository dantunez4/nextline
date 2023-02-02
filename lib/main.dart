import 'package:flutter/material.dart';
import 'package:gestion_tareas/screens/screens.dart';
import 'package:gestion_tareas/screens/task_form_screen.dart';
import 'package:gestion_tareas/services/tasks_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TasksService(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'task': (_) => const TaskFormScreen(),
      },
    );
  }
}
