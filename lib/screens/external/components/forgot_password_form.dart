import 'package:aiesecmembercheck/common/components/editor.dart';
import 'package:aiesecmembercheck/validators/field_validator.dart';
import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  const ForgotPasswordForm(
      {super.key, required this.emailController, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Editor(
            controller: emailController,
            label: 'E-mail',
            hint: 'Digite seu e-mail',
            validator: (value) => FieldValidator.validateAiesecEmail(value),
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}
