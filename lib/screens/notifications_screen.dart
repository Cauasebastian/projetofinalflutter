// lib/screens/notifications_screen.dart

import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<String> notifications = [
    "Você tem uma nova tarefa para revisar.",
    "Sua senha foi alterada com sucesso.",
    "Nova atualização disponível para o aplicativo.",
    "Tarefa 'Projeto A' foi concluída.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(notifications[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notificação removida')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
