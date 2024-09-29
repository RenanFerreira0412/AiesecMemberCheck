import 'package:aiesecmembercheck/models/user.dart';
import 'package:aiesecmembercheck/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  // Pega o ID do usuário
  String? userId() {
    return _firebaseAuth.currentUser?.uid;
  }

  // Pega o email do usuário
  String? userEmail() {
    return _firebaseAuth.currentUser?.email;
  }

  // Verifica possíveis erros de autenticação
  void handleAuthenticationError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
        throw AuthException('E-mail ou senha inválidos.');
      case 'invalid-email':
        throw AuthException('Email inválido.');
      case 'weak-password':
        throw AuthException('A senha precisa ter no mínimo 6 caracteres!');
      case 'email-already-in-use':
        throw AuthException('Este email já está cadastrado.');
      case 'user-not-found':
        throw AuthException('Usuário não encontrado.');
      case 'wrong-password':
        throw AuthException('Senha incorreta!');
      default:
        throw AuthException('Erro desconhecido.');
    }
  }

  // Cria um novo usuário com e-mail e senha
  Future<User?> registerWithEmail(String fullname, String cpf, String email,
      String password, String localCommittee) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Primeiro nome
        var firstname = fullname.split(' ')[0];

        // Adicionar o usuário à coleção no Firestore
        UserData newUser = UserData(
          uid: user.uid,
          fullname: fullname,
          firstname: firstname,
          email: user.email!,
          cpf: cpf,
          localCommittee: localCommittee,
          type: UserType.common, // Definindo o tipo do usuário
          creationDate: DateTime.now(),
        );
        await _userService.addUser(newUser);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      // Tratando os erros de autenticação
      handleAuthenticationError(e);
    }
    return null; // Retorna null se houver erro
  }

  // Faz login com e-mail e senha
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Tratando os erros de autenticação
      handleAuthenticationError(e);
    }
    return null; // Retorna null se houver erro
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Método para redefinir a senha
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      handleAuthenticationError(e);
    }
  }
}
