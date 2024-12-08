import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final TaskService _taskService = TaskService();

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    try {
      _tasks = await _taskService.fetchTasks();
      notifyListeners();
    } catch (e) {
      throw Exception('Falha ao carregar as tarefas');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _taskService.updateTask(task);
      int index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Falha ao atualizar a tarefa');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _taskService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      throw Exception('Falha ao excluir a tarefa');
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _taskService.addTask(task);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      throw Exception('Falha ao adicionar a tarefa');
    }
  }
  // Novo método: Alternar o status de favorito
  Future<void> toggleFavorite(int taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex >= 0) {
      final task = _tasks[taskIndex];
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        creationDate: task.creationDate,
        dueDate: task.dueDate,
        isFavorite: !task.isFavorite,  // Inverte o status de favorito
        completionDate: task.completionDate,
        userId: task.userId,
      );

      // Atualiza o status de favorito no backend
      await updateTask(updatedTask);  // Usa o método updateTask para atualizar o backend
    }
  }
}
