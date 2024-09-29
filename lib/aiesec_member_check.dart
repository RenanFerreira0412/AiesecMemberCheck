import 'package:aiesecmembercheck/routes/app_routes.dart';
import 'package:aiesecmembercheck/utils/utils.dart';
import 'package:flutter/material.dart';

class AiesecMemberCheck extends StatelessWidget {
  const AiesecMemberCheck({super.key});

  final String _title = 'Gestão de auditoria | AIESEC';

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: Utils.messengerKey,
      title: _title,
      routerConfig: routes,
    );
  }
}
