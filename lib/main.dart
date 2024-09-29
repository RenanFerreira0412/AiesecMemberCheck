import 'package:aiesecmembercheck/aiesec_member_check.dart';
import 'package:aiesecmembercheck/firebase_options.dart';
import 'package:aiesecmembercheck/providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
    ],
    child: const AiesecMemberCheck(),
  ));
}
