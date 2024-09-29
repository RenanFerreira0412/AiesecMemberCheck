import 'package:aiesecmembercheck/services/database_service.dart';
import 'package:aiesecmembercheck/models/user.dart';
import 'package:aiesecmembercheck/providers/auth_provider.dart';
import 'package:aiesecmembercheck/screens/external/volunteer_term_screen.dart';
import 'package:aiesecmembercheck/screens/internal/access_denied_ui.dart';
import 'package:aiesecmembercheck/screens/internal/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthManager extends StatefulWidget {
  const AuthManager({super.key});

  @override
  State<AuthManager> createState() => _AuthManagerState();
}

class _AuthManagerState extends State<AuthManager> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return loading();
    } else if (authProvider.currentUser == null) {
      return const VolunteerTermScreen();
    } else {
      return RoleBasedUI(authProvider: authProvider);
    }
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class RoleBasedUI extends StatelessWidget {
  final AuthProvider authProvider;

  RoleBasedUI({super.key, required this.authProvider});

  final dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: dbService.usersCollection
          .doc(authProvider.currentUser!.uid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Algo deu errado.'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var data = snapshot.data!;
        UserData user =
            UserData.fromFirestore(data); // Utiliza o método fromFirestore

        return checkRole(user, authProvider);
      },
    );
  }

  Widget checkRole(UserData user, AuthProvider authProvider) {
    if (user.type == UserType.superadmin) {
      return Container();
    } else if (user.type == UserType.admin) {
      return const HomeScreen();
    } else {
      return AccessDeniedUI(authProvider: authProvider);
    }
  }
}
