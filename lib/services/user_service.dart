import 'package:aiesecmembercheck/models/user.dart';
import 'package:aiesecmembercheck/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final DatabaseService _databaseService = DatabaseService();

  // Adiciona um novo usuário na coleção users
  Future<void> addUser(UserData user) async {
    try {
      await _databaseService.usersCollection
          .doc(user.uid)
          .set(user.toFirestore());
    } catch (e) {
      print('Erro ao adicionar usuário: $e');
      throw Exception('Erro ao adicionar usuário');
    }
  }

  // Obtém os dados de um usuário com base no uid
  Future<UserData?> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _databaseService.usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserData.fromFirestore(doc);
      } else {
        return null; // Usuário não encontrado
      }
    } catch (e) {
      print('Erro ao obter usuário: $e');
      throw Exception('Erro ao obter usuário');
    }
  }

  // Atualiza os dados de um usuário
  Future<void> updateUser(UserData user) async {
    try {
      await _databaseService.usersCollection
          .doc(user.uid)
          .update(user.toFirestore());
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
      throw Exception('Erro ao atualizar usuário');
    }
  }

  // Remove um usuário com base no uid
  Future<void> deleteUser(String uid) async {
    try {
      await _databaseService.usersCollection.doc(uid).delete();
    } catch (e) {
      print('Erro ao deletar usuário: $e');
      throw Exception('Erro ao deletar usuário');
    }
  }
}
