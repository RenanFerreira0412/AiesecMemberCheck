import 'package:aiesecmembercheck/common/widgets/primary_button.dart';
import 'package:aiesecmembercheck/providers/auth_provider.dart';
import 'package:aiesecmembercheck/screens/external/components/forgot_password_form.dart';
import 'package:aiesecmembercheck/screens/external/components/login_form.dart';
import 'package:aiesecmembercheck/screens/external/components/register_form.dart';
import 'package:aiesecmembercheck/services/auth_service.dart';
import 'package:aiesecmembercheck/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isForgotPassword = false;

  // Controladores
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final cpfController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final committeeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Textos da tela de autenticação
  late String title;
  late String actionButtonTitle;
  late String toggleButton;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    cpfController.dispose();
    confirmPasswordController.dispose();
    committeeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setAuthText();
  }

  // Função para definir os textos com base no estado de autenticação
  void _setAuthText() {
    if (isForgotPassword) {
      title = 'Recuperar Senha';
      actionButtonTitle = 'Recuperar Senha';
      toggleButton = 'Voltar para o login';
    } else if (isLogin) {
      title = 'Login';
      actionButtonTitle = 'Entrar';
      toggleButton = 'Ainda não tem uma conta? Cadastre-se';
    } else {
      title = 'Cadastro';
      actionButtonTitle = 'Cadastrar';
      toggleButton = 'Já tem uma conta? Entre';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () => context.go('/'),
          child: Image.asset(
            'assets/images/aiesec_logo.png',
            width: 200,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                  Utils.addVerticalSpace(16.0),

                  // Botão para alternar entre Login e Cadastro
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin =
                            !isLogin; // Alterna entre as telas de login e cadastro
                        isForgotPassword =
                            false; // Reseta a tela de recuperação
                        formKey.currentState
                            ?.reset(); // Reinicia a validação do formulário
                        _setAuthText(); // Atualiza os textos
                      });
                    },
                    child: Text(
                      toggleButton,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Utils.addVerticalSpace(20.0),

                  // Exibe o formulário de acordo com a tela selecionada
                  if (isLogin && !isForgotPassword) ...[
                    // Formulário de Login
                    LoginForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      formKey: formKey,
                      onForgotPassword: () {
                        setState(() {
                          isForgotPassword =
                              true; // Altera para a tela de recuperação
                          isLogin = false; // Reseta a tela de login
                          formKey.currentState
                              ?.reset(); // Reinicia a validação do formulário
                          _setAuthText(); // Atualiza os textos
                        });
                      },
                    ),
                  ] else if (!isLogin && !isForgotPassword) ...[
                    // Formulário de Registro
                    RegisterForm(
                      nameController: nameController,
                      cpfController: cpfController,
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      committeeController: committeeController,
                      formKey: formKey,
                    ),
                  ] else ...[
                    // Formulário de Recuperação de Senha
                    ForgotPasswordForm(
                      emailController: emailController,
                      formKey: formKey,
                    ),
                  ],
                  Utils.addVerticalSpace(15.0),

                  PrimaryButton(
                    label: actionButtonTitle,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // Processar o formulário
                        if (isLogin) {
                          await _handleLogin(emailController.text.trim(),
                              passwordController.text.trim());
                        } else if (isForgotPassword) {
                          await _handlePasswordReset(
                              emailController.text.trim());
                        } else {
                          await _handleRegistration(
                            nameController.text.trim(),
                            cpfController.text.trim(),
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            committeeController.text.trim(),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(String email, String password) async {
    try {
      await context.read<AuthProvider>().loginWithEmail(email, password);
      if (!mounted) return;
      context.go('/');
    } on AuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  Future<void> _handleRegistration(String fullname, String cpf, String email,
      String password, String localCommittee) async {
    try {
      await context
          .read<AuthProvider>()
          .registerWithEmail(fullname, cpf, email, password, localCommittee);
      if (!mounted) return;
      context.go('/');
    } on AuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }

  Future<void> _handlePasswordReset(String email) async {
    try {
      await context.read<AuthProvider>().resetPassword(email);
      Utils.showSnackBar(
          'E-mail de redefinição de senha enviado com sucesso! Por favor, verifique sua caixa de entrada.');
    } on AuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }
}
