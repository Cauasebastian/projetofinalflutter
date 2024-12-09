import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  User? _user;
  bool _isLoading = false; // Indica se uma operação está em andamento
  String? _errorMessage; // Armazena mensagens de erro, se houver

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Carrega o usuário do backend
  Future<void> loadUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      User fetchedUser = await _userService.fetchCurrentUser();
      _user = fetchedUser;
    } catch (e) {
      _errorMessage = e.toString();
      _user = null;
      // Opcional: Implementar lógica de redirecionamento para login se o token for inválido
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Atualiza o usuário no backend e localmente
  Future<void> updateUser({
    String? name,
    String? email,
    String? password, // **Nota:** Evite manipular a senha dessa forma
    DateTime? dateOfBirth,
  }) async {
    if (_user == null) {
      throw Exception('Usuário não carregado');
    }

    // Cria um novo objeto User com os campos atualizados
    User updatedUser = User(
      id: _user!.id,
      name: name ?? _user!.name,
      email: email ?? _user!.email,
      password: password, // Apenas envia se não for nulo
      dateOfBirth: dateOfBirth ?? _user!.dateOfBirth,
    );

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _userService.updateUser(updatedUser);
      _user = updatedUser;
    } catch (e) {
      _errorMessage = e.toString();
      print('Erro ao atualizar o usuário: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para alterar a senha do usuário
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _userService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      // Opcional: Implementar lógica adicional, como logout
    } catch (e) {
      _errorMessage = e.toString();
      print('Erro ao alterar a senha: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para logout
  Future<void> logout() async {
    await _userService.logout();
    _user = null;
    notifyListeners();
  }
}
