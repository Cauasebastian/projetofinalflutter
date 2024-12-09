import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart'; // Import the UserProvider
import 'edit_profile_screen.dart';
import 'login_screen.dart'; // Import your login screen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isInit = true; // Flag para garantir que loadUser seja chamado apenas uma vez

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      // Utiliza addPostFrameCallback para chamar loadUser após a construção inicial
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.loadUser(); // Chama loadUser para buscar os dados do usuário
      });
      _isInit = false;
    }
  }

  // Função para formatar a data
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : userProvider.errorMessage != null
            ? Center(child: Text('Erro: ${userProvider.errorMessage}'))
            : user == null
            ? const Center(child: Text('Nenhum dado do usuário encontrado.'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(user.email, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'Data de Nascimento: ${user.dateOfBirth != null ? _formatDate(user.dateOfBirth!) : 'Não informado'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const EditProfileScreen()),
                );
              },
              child: const Text('Editar Perfil'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await userProvider.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>  LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
