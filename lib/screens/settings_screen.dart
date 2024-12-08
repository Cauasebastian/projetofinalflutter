import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart'; // Importando o ThemeProvider
import 'help_screen.dart'; // Importando a tela de Ajuda
import 'about_screen.dart';
import 'notifications_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Switch para alterar o tema escuro
            SwitchListTile(
              title: const Text('Tema Escuro'),
              value: Provider.of<ThemeProvider>(context).isDarkTheme,
              onChanged: (bool value) {
                // Altera o tema utilizando o ThemeProvider
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
            ),
            const Divider(),

            // Link para configurações de Notificações
            ListTile(
              title: const Text('Notificações'),
              onTap: () {
                // Navega para a tela de notificações
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsScreen()),
                );
              },
            ),
            const Divider(),

            // Link para a tela "Sobre"
            ListTile(
              title: const Text('Sobre'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
            const Divider(),

            // Link para a tela "Ajuda"
            ListTile(
              title: const Text('Ajuda'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
