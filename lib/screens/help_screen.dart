// lib/screens/help_screen.dart

import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  final List<Map<String, String>> helpTopics = [
    {
      "title": "Como criar uma nova tarefa?",
      "content": "Para criar uma nova tarefa, vá para a tela principal e toque no botão '+'."
    },
    {
      "title": "Como editar meu perfil?",
      "content": "Acesse a tela de perfil e toque no botão 'Editar Perfil'."
    },
    {
      "title": "Esqueci minha senha, e agora?",
      "content": "Na tela de login, toque em 'Recuperar senha' e siga as instruções."
    },
    {
      "title": "Como alterar configurações?",
      "content": "Vá para a tela de configurações e personalize as opções disponíveis."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajuda'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: helpTopics.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ExpansionTile(
              title: Text(helpTopics[index]["title"]!),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(helpTopics[index]["content"]!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
