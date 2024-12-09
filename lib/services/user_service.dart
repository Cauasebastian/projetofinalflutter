import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String baseUrl = 'http://192.168.15.106:8080/users'; // Substitua pelo URL real do seu backend

  // Função para obter o token do SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Função para obter as informações do usuário autenticado
  Future<User> fetchCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      log('Iniciando requisição GET para $baseUrl', name: 'fetchCurrentUser');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar o token no cabeçalho
        },
      );
      log('Resposta recebida: Status Code ${response.statusCode}', name: 'fetchCurrentUser');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        log('Resposta JSON: $jsonResponse', name: 'fetchCurrentUser');
        return User.fromJson(jsonResponse);
      } else {
        log('Erro ao carregar o usuário: ${response.body}', name: 'fetchCurrentUser');
        throw Exception('Falha ao carregar as informações do usuário');
      }
    } catch (e) {
      log('Erro ao fazer requisição GET: $e', name: 'fetchCurrentUser');
      rethrow;
    }
  }

  // Função para atualizar as informações do usuário
  Future<void> updateUser(User user) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      log('Iniciando requisição PUT para $baseUrl', name: 'updateUser');
      log('Dados do usuário para atualização: ${user.toJson()}', name: 'updateUser');
      final response = await http.put(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar o token no cabeçalho
        },
        body: json.encode(user.toJson()),
      );
      log('Resposta recebida: Status Code ${response.statusCode}', name: 'updateUser');

      if (response.statusCode == 200) {
        log('Usuário atualizado com sucesso: ${response.body}', name: 'updateUser');
      } else {
        log('Erro ao atualizar o usuário: ${response.body}', name: 'updateUser');
        throw Exception('Falha ao atualizar o usuário');
      }
    } catch (e) {
      log('Erro ao fazer requisição PUT para atualizar o usuário: $e', name: 'updateUser');
      rethrow;
    }
  }

  // Função para alterar a senha do usuário
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final String url = '$baseUrl/change-password'; // Substitua pelo URL real do seu backend

    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      log('Iniciando requisição POST para $url', name: 'changePassword');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );
      log('Resposta recebida: Status Code ${response.statusCode}', name: 'changePassword');

      if (response.statusCode == 200) {
        log('Senha atualizada com sucesso', name: 'changePassword');
      } else {
        log('Erro ao alterar a senha: ${response.body}', name: 'changePassword');
        throw Exception('Falha ao alterar a senha: ${response.body}');
      }
    } catch (e) {
      log('Erro ao fazer requisição POST para alterar a senha: $e', name: 'changePassword');
      rethrow;
    }
  }

  // Função para fazer logout (remover o token)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }
}
