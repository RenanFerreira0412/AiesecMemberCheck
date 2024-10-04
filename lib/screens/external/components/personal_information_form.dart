import 'package:aiesecmembercheck/common/components/editor.dart';
import 'package:aiesecmembercheck/common/components/selection_field.dart';
import 'package:aiesecmembercheck/repository/career_repository.dart';
import 'package:aiesecmembercheck/utils/utils.dart';
import 'package:aiesecmembercheck/validators/field_validator.dart';
import 'package:flutter/material.dart';
import 'package:aiesecmembercheck/utils/device_helper.dart';

class PersonalInformationForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController birthdayController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController rgController;
  final TextEditingController cpfController;
  final TextEditingController issuingAuthorityController;
  final TextEditingController careerController;
  final GlobalKey<FormState> formKey;

  const PersonalInformationForm(
      {super.key,
      required this.nameController,
      required this.birthdayController,
      required this.phoneController,
      required this.emailController,
      required this.rgController,
      required this.cpfController,
      required this.issuingAuthorityController,
      required this.careerController,
      required this.formKey});

  // Função que retorna a lista de campos do formulário
  List<Widget> _buildFormFields() {
    return [
      Editor(
        controller: nameController,
        label: 'Nome',
        hint: 'Seu nome completo',
        obscureText: false,
        keyboardType: TextInputType.name,
        validator: (value) => FieldValidator.validateRequired(value, 'Nome'),
      ),
      Editor(
        controller: birthdayController,
        label: 'Data de Nascimento',
        hint: 'dd/mm/aaaa',
        obscureText: false,
        keyboardType: TextInputType.datetime,
        mask: "##/##/####",
        validator: (value) =>
            FieldValidator.validateRequired(value, 'Data de nascimento'),
      ),
      Editor(
        controller: phoneController,
        label: 'Telefone',
        hint: 'Seu telefone',
        obscureText: false,
        keyboardType: TextInputType.phone,
        mask: '(##) #####-####',
        validator: (value) =>
            FieldValidator.validateRequired(value, 'Telefone'),
      ),
      Editor(
        controller: emailController,
        label: 'Email',
        hint: 'Seu email',
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => FieldValidator.validateEmail(value),
      ),
      Editor(
        controller: cpfController,
        label: 'CPF',
        hint: 'Seu CPF',
        obscureText: false,
        mask: '###-###-###.##',
        keyboardType: TextInputType.number,
        validator: (value) => FieldValidator.validateRequired(value, 'CPF'),
      ),
      Editor(
        controller: rgController,
        label: 'RG',
        hint: 'Seu RG',
        obscureText: false,
        keyboardType: TextInputType.number,
        validator: (value) => FieldValidator.validateRequired(value, 'RG'),
      ),
      Editor(
        controller: issuingAuthorityController,
        label: 'Órgão Emissor',
        hint: 'Órgão emissor do RG/UF (ex.: SSP/SC)',
        obscureText: false,
        keyboardType: TextInputType.text,
        validator: (value) =>
            FieldValidator.validateRequired(value, 'Órgão emissor'),
      ),
      SelectionField(
          controller: careerController,
          label: 'Área de atuação',
          hint: 'Sua área de atuação (ex.: Estudante, TI, Administração, etc.)',
          items: CareerRepository.careers,
          validator: (value) =>
              FieldValidator.validateRequired(value, 'Área de atuação'))
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = DeviceHelper.isDesktop(context);
    const double spacing = 16.0;
    final fields = _buildFormFields();

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: isDesktop
            ? Column(
                children: [
                  for (int i = 0; i < fields.length; i += 2)
                    Padding(
                      padding: const EdgeInsets.only(bottom: spacing),
                      child: Row(
                        children: [
                          Expanded(child: fields[i]),
                          if (i + 1 < fields.length) ...[
                            Utils.addHorizontalSpace(spacing),
                            Expanded(child: fields[i + 1]),
                          ],
                        ],
                      ),
                    ),
                ],
              )
            : Column(
                children: fields
                    .map((field) => Padding(
                          padding: const EdgeInsets.only(bottom: spacing),
                          child: field,
                        ))
                    .toList(),
              ),
      ),
    );
  }
}
