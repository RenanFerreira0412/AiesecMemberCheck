import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Coleção de usuários
  CollectionReference get usersCollection {
    return _db.collection('users');
  }

  // Coleção de membros
  CollectionReference get membersCollection {
    return _db.collection('members');
  }

  // Coleção de cargos
  CollectionReference get jobTitlesCollection {
    return _db.collection('job_titles');
  }

  // Coleção de cargos
  CollectionReference get localCommitteesCollection {
    return _db.collection('local_committees');
  }
}
