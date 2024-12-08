import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer_widget.dart';
import '../providers/task_provider.dart';
import 'task_detail_screen.dart';
import '../models/task.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Chama o método fetchTasks assim que o widget for iniciado
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.fetchTasks(); // Carregar as tarefas inicialmente
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Gerenciador de Tarefas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newTask = await Navigator.pushNamed(context, '/addTask') as Task?;
              if (newTask != null) {
                taskProvider.addTask(newTask);
                // Atualiza a lista de tarefas após adicionar uma nova tarefa
                setState(() {
                  taskProvider.fetchTasks(); // Recarregar as tarefas
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implementar ação de busca (opcional)
            },
          ),
        ],
      ),
      body: taskProvider.tasks.isEmpty
          ? Center(
        child: Text('Nenhuma tarefa adicionada.'),
      )
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          var task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('Entrega: ${formatDateTime(task.dueDate)}'),
            trailing: Icon(
              task.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: task.isFavorite ? Colors.red : null,
            ),
            onTap: () async {
              final updatedTask = await Navigator.push<Task>(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailScreen(task: task),
                ),
              );

              if (updatedTask != null) {
                taskProvider.updateTask(updatedTask);
              }
            },
          );
        },
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
