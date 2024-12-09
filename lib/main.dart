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
import 'screens/help_screen.dart'; // Importando a tela de Ajuda
import 'screens/about_screen.dart';
import '/screens/notifications_screen.dart';
import 'screens/PasswordRecoveryScreen.dart';
import 'screens/settings_screen.dart'; // Import the Settings screen
import 'providers/task_provider.dart';
import 'services/auth_service.dart';
import 'providers/theme_provider.dart'; // Importar o ThemeProvider
import 'screens/favorite_screen.dart'; // Import da FavoriteScreen


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessário para inicializar o SharedPreferences
  String? token = await AuthService.getToken(); // Verifique o token

  runApp(TaskManagerApp(token: token));
}

class TaskManagerApp extends StatelessWidget {
  final String? token;

  TaskManagerApp({required this.token});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
          ChangeNotifierProvider<TaskProvider>(create: (_) => TaskProvider()),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()), // Adicionando o ThemeProvider
        ],
        child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
      return MaterialApp(
        title: 'Gerenciador de Tarefas',
        theme: themeProvider.isDarkTheme
            ? ThemeData.dark() // Tema escuro
            : ThemeData.light(), // Tema claro
        initialRoute: token == null ? '/login' : '/main',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/main': (context) => MainScreen(),
          '/addTask': (context) => AddTaskScreen(),
          '/Recovery': (context) => PasswordRecoveryScreen(),
          '/profile': (context) => ProfileScreen(),  // Profile Screen Route
          '/editProfile': (context) => EditProfileScreen(),
          '/settings': (context) => SettingsScreen(),
          '/help': (context) => HelpScreen(), // Rota para a tela de Ajuda
          '/about': (context) => AboutScreen(),
          '/notification': (context) => NotificationsScreen(),
          '/favorites': (context) => const FavoriteScreen(),
        },
      );
        },
        ),
    );
  }
}