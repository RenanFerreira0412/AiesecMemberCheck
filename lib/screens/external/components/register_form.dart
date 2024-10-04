import 'package:aiesecmembercheck/common/components/editor.dart';
import 'package:aiesecmembercheck/common/components/selection_field.dart';
import 'package:aiesecmembercheck/services/local_committees_service.dart';
import 'package:aiesecmembercheck/validators/field_validator.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController cpfController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController committeeController;
  final GlobalKey<FormState> formKey;

  const RegisterForm({
    super.key,
    required this.nameController,
    required this.cpfController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    required this.committeeController,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final LocalCommitteeService _committeeService = LocalCommitteeService();
  List<String> _committees = [];

  @override
  void initState() {
    super.initState();
    _loadCommittees();
  }

  Future<void> _loadCommittees() async {
    List<String> committees = await _committeeService.getLocalCommittees();
    setState(() {
      _committees = committees;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Editor(
            controller: widget.nameController,
            label: 'Nome',
            hint: 'Digite seu nome completo',
            validator: (value) =>
                FieldValidator.validateRequired(value, 'Nome'),
            obscureText: false,
            keyboardType: TextInputType.name,
          ),
          Editor(
            controller: widget.cpfController,
            label: 'CPF',
            hint: 'Digite o número do seu CPF',
            validator: (value) => FieldValidator.validateRequired(value, 'CPF'),
            mask: '###-###-###.##',
            obscureText: false,
            keyboardType: TextInputType.text,
          ),
          SelectionField(
              controller: widget.committeeController,
              label: 'Comitê Local',
              hint: 'Selecione um comitê',
              items: _committees,
              validator: (value) =>
                  FieldValidator.validateRequired(value, 'Comitê Local')),
          Editor(
            controller: widget.emailController,
            label: 'E-mail',
            hint: 'Digite seu e-mail',
            validator: (value) => FieldValidator.validateAiesecEmail(value),
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
          ),
          Editor(
            controller: widget.passwordController,
            label: 'Senha',
            hint: 'Digite sua senha',
            obscureText: true,
            validator: (value) => FieldValidator.validatePassword(value),
            keyboardType: TextInputType.text,
          ),
          Editor(
            controller: widget.confirmPasswordController,
            label: 'Confirmar senha',
            hint: 'Digite novamente sua senha',
            obscureText: true,
            validator: (value) => FieldValidator.validateConfirmPassword(
              widget.passwordController.text,
              value,
            ),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
