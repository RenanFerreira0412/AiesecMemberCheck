import 'package:aiesecmembercheck/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? currentUser;
  bool isLoading = true;

  AuthProvider() {
    _authCheck();
  }

  // Verificando o estado do usuário (autenticado ou não)
  void _authCheck() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      currentUser = user; // Se user for null, currentUser será null
      isLoading = false; // Atualiza o estado de loading
      notifyListeners(); // Notifica ouvintes sobre as alterações
    });
  }

  // Método para registrar um novo usuário
  Future<void> registerWithEmail(String fullname, String cpf, String email,
      String password, String localCommittee) async {
    currentUser = await _authService.registerWithEmail(
        fullname, cpf, email, password, localCommittee);
    notifyListeners();
  }

  // Método para fazer login com email e senha
  Future<void> loginWithEmail(String email, String password) async {
    currentUser = await _authService.loginWithEmail(email, password);
    notifyListeners();
  }

  // Método para fazer logout
  Future<void> logout() async {
    await _authService.logout();
    currentUser = null; // Reseta o usuário atual
    notifyListeners();
  }

  // Método para redefinir a senha
  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
    notifyListeners(); // Notifica ouvintes sobre a alteração (opcional)
  }
}
