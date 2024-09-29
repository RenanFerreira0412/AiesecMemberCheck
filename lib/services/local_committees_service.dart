import 'package:aiesecmembercheck/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocalCommitteeService {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<String>> getLocalCommittees() async {
    List<String> committees = [];
    try {
      QuerySnapshot snapshot =
          await _databaseService.localCommitteesCollection.get();
      for (var doc in snapshot.docs) {
        committees.add(doc['name']);
      }
    } catch (e) {
      print('Erro ao carregar comitês: $e');
    }
    return committees;
  }
}
