import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { common, admin, superadmin }

class UserData {
  final String uid;
  final String fullname;
  final String firstname;
  final String email;
  final String cpf;
  final String localCommittee;
  final UserType type; // Pode ser 'common', 'admin' ou 'superadmin'
  final DateTime creationDate;

  UserData({
    required this.uid,
    required this.fullname,
    required this.firstname,
    required this.email,
    required this.cpf,
    required this.localCommittee,
    required this.type,
    required this.creationDate,
  });

  // Converte um DocumentSnapshot do Firestore para um objeto UserData
  factory UserData.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return UserData(
      uid: data['uid'] ?? '',
      fullname: data['full_name'] ?? '',
      firstname: data['first_name'] ?? '',
      email: data['email'] ?? '',
      cpf: data['cpf'] ?? '',
      localCommittee: data['localCommittee'] ?? '',
      type: _fromFirestoreType(data['type']), // Chama o método de conversão
      creationDate:
          (data['creation_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Converte o tipo de string do Firestore para o enum UserType
  static UserType _fromFirestoreType(String? type) {
    switch (type) {
      case 'admin':
        return UserType.admin;
      case 'superadmin':
        return UserType.superadmin;
      case 'common':
      default:
        return UserType.common;
    }
  }

  // Converte um objeto UserData para um mapa que pode ser salvo no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'full_name': fullname,
      'first_name': firstname,
      'email': email,
      'cpf': cpf,
      'localCommittee': localCommittee,
      'type': _toFirestoreType(type), // Chama o método de conversão
      'creation_date': Timestamp.fromDate(creationDate),
    };
  }

  // Converte o enum UserType para uma string para ser salva no Firestore
  static String _toFirestoreType(UserType type) {
    switch (type) {
      case UserType.admin:
        return 'admin';
      case UserType.superadmin:
        return 'superadmin';
      case UserType.common:
      default:
        return 'common';
    }
  }
}
