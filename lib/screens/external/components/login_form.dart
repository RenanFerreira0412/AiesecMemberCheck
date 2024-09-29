import 'package:aiesecmembercheck/common/components/editor.dart';
import 'package:aiesecmembercheck/validators/field_validator.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final void Function() onForgotPassword;

  const LoginForm(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.formKey,
      required this.onForgotPassword});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Editor(
            controller: emailController,
            label: 'E-mail',
            hint: 'Digite seu e-mail',
            obscureText: false,
            validator: (value) => FieldValidator.validateEmail(value),
            keyboardType: TextInputType.emailAddress,
          ),
          Editor(
            controller: passwordController,
            label: 'Senha',
            hint: 'Digite sua senha',
            obscureText: true,
            validator: FieldValidator.validatePassword,
            keyboardType: TextInputType.text,
          ),
          TextButton(
            onPressed: onForgotPassword,
            child: const Text('Esqueceu a senha?'),
          ),
        ],
      ),
    );
  }
}
