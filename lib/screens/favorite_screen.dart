import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'task_detail_screen.dart'; // Supondo que você tenha uma tela de detalhes da tarefa
import '../widgets/drawer_widget.dart'; // Certifique-se de importar o Drawer

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  // Função para formatar a data
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas Favoritas'),
      ),
      drawer: AppDrawer(), // Adiciona o Drawer aqui
      body: FutureBuilder(
        future: Provider.of<TaskProvider>(context, listen: false).fetchTasks(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Enquanto estiver carregando
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Se houver um erro
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            // Depois que os dados foram carregados
            return Consumer<TaskProvider>(
              builder: (ctx, taskProvider, _) {
                List<Task> favoriteTasks = taskProvider.tasks.where((task) => task.isFavorite).toList();

                if (favoriteTasks.isEmpty) {
                  return const Center(child: Text('Nenhuma tarefa favorita encontrada.'));
                }

                return ListView.builder(
                  itemCount: favoriteTasks.length,
                  itemBuilder: (ctx, index) {
                    final task = favoriteTasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text('Prazo: ${_formatDate(task.dueDate)}'),
                        trailing: IconButton(
                          icon: Icon(
                            task.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: task.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            Provider.of<TaskProvider>(context, listen: false).toggleFavorite(task.id);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => TaskDetailScreen(task: task), // Passa o objeto Task completo
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
