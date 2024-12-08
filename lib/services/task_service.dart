import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  final String baseUrl = 'http://192.168.15.106:8080/api/tasks'; // Substitua pelo URL real do seu backend

  // Função para obter o token do SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Função para obter todas as tarefas
  Future<List<Task>> fetchTasks() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      log('Iniciando requisição GET para $baseUrl', name: 'fetchTasks');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token' // Enviar o token no cabeçalho
        },
      );
      log('Resposta recebida: Status Code ${response.statusCode}', name: 'fetchTasks');

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        log('Resposta JSON: $jsonResponse', name: 'fetchTasks');
        return jsonResponse.map((task) => Task.fromJson(task)).toList();
      } else {
        log('Erro ao carregar as tarefas: ${response.body}', name: 'fetchTasks');
        throw Exception('Falha ao carregar as tarefas');
      }
    } catch (e) {
      log('Erro ao fazer requisição GET: $e', name: 'fetchTasks');
      rethrow;
    }
  }

  // Função para obter uma tarefa pelo ID
  Future<Task> fetchTaskById(int id) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      log('Iniciando requisição GET para $baseUrl/$id', name: 'fetchTaskById');
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token' // Enviar o token no cabeçalho
        },
      );
      log('Resposta recebida: Status Code ${response.statusCode}', name: 'fetchTaskById');

      if (response.statusCode == 200) {
        log('Resposta JSON: ${response.body}', name: 'fetchTaskById');
        return Task.fromJson(json.decode(response.body));
      } else {
        log('Erro ao carregar a tarefa com ID $id: ${response.body}', name: 'fetchTaskById');
        throw Exception('Falha ao carregar a tarefa');
      }
    } catch (e) {
      log('Erro ao fazer requisição GET para o ID $id: $e', name: 'fetchTaskById');
      rethrow;
    }
  }

  // Função para atualizar uma tarefa
  Future<void> updateTask(Task task) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      log('Iniciando requisição PUT para $baseUrl/${task.id}', name: 'updateTask');
      log('Dados da Tarefa para atualização: ${task.toJson()}', name: 'updateTask');
      final response = await http.put(
        Uri.parse('$baseUrl/${task.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token' // Enviar o token no cabeçalho
        },
        body: json.encode(task.toJson()),
      );
      log('Resposta recebida: Status Code ${response.statusCode}', name: 'updateTask');

      if (response.statusCode != 200) {
        log('Erro ao atualizar a tarefa: ${response.body}', name: 'updateTask');
        throw Exception('Falha ao atualizar a tarefa');
      }
    } catch (e) {
      log('Erro ao fazer requisição PUT para atualizar a tarefa: $e', name: 'updateTask');
      rethrow;
    }
  }

  // Função para deletar uma tarefa
  Future<void> deleteTask(int id) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      log('Iniciando requisição DELETE para $baseUrl/$id', name: 'deleteTask');
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token' // Enviar o token no cabeçalho
        },
      );
      log('Resposta recebida: Status Code ${response.statusCode}', name: 'deleteTask');

      if (response.statusCode != 200) {
        log('Erro ao excluir a tarefa com ID $id: ${response.body}', name: 'deleteTask');
        throw Exception('Falha ao excluir a tarefa');
      }
    } catch (e) {
      log('Erro ao fazer requisição DELETE para o ID $id: $e', name: 'deleteTask');
      rethrow;
    }
  }

  // Função para adicionar uma nova tarefa
  Future<void> addTask(Task task) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      log('Iniciando requisição POST para $baseUrl', name: 'addTask');
      log('Dados da nova tarefa a ser adicionada: ${task.toJson()}', name: 'addTask');
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token' // Enviar o token no cabeçalho
        },
        body: json.encode(task.toJson()), // Envia os dados como JSON
      );
      log('Resposta recebida: Status Code ${response.statusCode}', name: 'addTask');

      if (response.statusCode == 200) {
        log('Tarefa adicionada com sucesso: ${response.body}', name: 'addTask');
      } else {
        log('Erro ao adicionar a tarefa: ${response.body}', name: 'addTask');
        throw Exception('Falha ao adicionar a tarefa');
      }
    } catch (e) {
      log('Erro ao fazer requisição POST para adicionar a tarefa: $e', name: 'addTask');
      rethrow;
    }
  }
}
