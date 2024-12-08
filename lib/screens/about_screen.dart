import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Verificando o tema atual
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
        backgroundColor: isDarkTheme ? Colors.black : Colors.blueAccent, // Cor do AppBar no modo escuro
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/512/3771/3771372.png',
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Gerenciador de Tarefas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.blueAccent, // Cor do título
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'O que é o Gerenciador de Tarefas?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black, // Cor do subtítulo
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'O Gerenciador de Tarefas é um aplicativo que te ajuda a organizar suas tarefas diárias de forma eficiente e prática. Com ele, você pode:',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkTheme ? Colors.white70 : Colors.black87, // Cor do texto no modo escuro
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  '- Adicionar, editar e excluir tarefas\n'
                      '- Categorizar tarefas por prioridade\n'
                      '- Definir lembretes e prazos\n'
                      '- Visualizar seu progresso ao longo do tempo',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkTheme ? Colors.white70 : Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),  // Aumentar o espaço antes do botão
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Sobre os Desenvolvedores'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                DeveloperInfo(
                                  name: 'Cauã Sebastian',
                                  role: 'Desenvolvedor Back-End',
                                ),
                                DeveloperInfo(
                                  name: 'Felipe',
                                  role: 'Desenvolvedor Front-End',
                                ),
                                DeveloperInfo(
                                  name: 'Edgar Tavares',
                                  role: 'Desenvolvedor Front-End',
                                ),
                                DeveloperInfo(
                                  name: 'Lara Nunes',
                                  role: 'UX Design',
                                ),
                                DeveloperInfo(
                                  name: 'Maria Helena',
                                  role: 'UX Design',
                                ),
                                DeveloperInfo(
                                  name: 'Thales Thiago',
                                  role: 'Pentester',
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Fechar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Saiba Mais'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkTheme ? Colors.blue : Colors.blue, // Cor do botão
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    foregroundColor: isDarkTheme ? Colors.white : Colors.black, // Cor do texto
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeveloperInfo extends StatelessWidget {
  final String name;
  final String role;

  DeveloperInfo({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDarkTheme ? Colors.white : Colors.black, // Cor do nome no modo escuro
            ),
          ),
          Text(
            role,
            style: TextStyle(
              color: isDarkTheme ? Colors.white70 : Colors.black54, // Cor do cargo no modo escuro
            ),
          ),
        ],
      ),
    );
  }
}
