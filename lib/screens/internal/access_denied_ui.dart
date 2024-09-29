import 'package:aiesecmembercheck/providers/auth_provider.dart';
import 'package:aiesecmembercheck/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccessDeniedUI extends StatelessWidget {
  final AuthProvider authProvider;

  const AccessDeniedUI({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acesso Restrito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Você não tem permissão para acessar esta seção.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Utils.addVerticalSpace(20.0),
              const Text(
                'Apenas administradores têm acesso a esta área. Para voltar ao formulário, clique no botão abaixo.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              Utils.addVerticalSpace(20.0),
              ElevatedButton(
                onPressed: () {
                  authProvider.logout(); // Chama o método de logout
                  context.go('/');
                },
                child: const Text('Voltar ao Formulário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
