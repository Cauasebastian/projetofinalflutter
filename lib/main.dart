import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart'; // Import the UserProvider
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/task_detail_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/PasswordRecoveryScreen.dart';
import 'screens/settings_screen.dart'; // Import the Settings screen
import 'providers/task_provider.dart';


Future<void> main() async {
  runApp(TaskManagerApp());
}


class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>(create: (_) => TaskProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()), // Provide UserProvider here
      ],
      child: MaterialApp(
        title: 'Gerenciador de Tarefas',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/main': (context) => MainScreen(),
          '/addTask': (context) => AddTaskScreen(),
          '/Recovery': (context) => PasswordRecoveryScreen(),
          '/profile': (context) => ProfileScreen(),  // Profile Screen Route
          '/editProfile': (context) => EditProfileScreen(),
          '/settings': (context) => SettingsScreen(),
        },
      ),
    );
  }
}