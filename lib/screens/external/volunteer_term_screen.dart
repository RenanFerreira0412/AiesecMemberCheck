import 'package:aiesecmembercheck/screens/external/components/personal_information_form.dart';
import 'package:aiesecmembercheck/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VolunteerTermScreen extends StatefulWidget {
  const VolunteerTermScreen({super.key});

  @override
  State<VolunteerTermScreen> createState() => _VolunteerTermScreenState();
}

class _VolunteerTermScreenState extends State<VolunteerTermScreen> {
  final String _title = "Formulário de Termo de Voluntariado";

  int currentStep = 0;
  bool isCompleted = false;

  // Controllers para o formulário
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _rgController = TextEditingController();
  final _cpfController = TextEditingController();
  final _issuingAuthorityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _careerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Liberar os controladores para evitar vazamento de memória
    _nameController.dispose();
    _birthdayController.dispose();
    _rgController.dispose();
    _cpfController.dispose();
    _issuingAuthorityController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _careerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
              onPressed: () => context.go('/authentication'),
              icon: const Icon(Icons.admin_panel_settings_rounded))
        ],
      ),
      body: isCompleted
          ? buildCompleted()
          : Stepper(
              type: StepperType.vertical,
              currentStep: currentStep,
              onStepCancel: () =>
                  currentStep == 0 ? null : setState(() => currentStep -= 1),
              onStepContinue: () {
                final isLastStep = currentStep == _getSteps().length - 1;

                if (_formKey.currentState!.validate()) {
                  if (isLastStep) {
                    // Lógica de submissão ao banco de dados
                    setState(() => isCompleted = true);
                    print('Submissão concluída');
                  } else {
                    setState(() => currentStep += 1);
                  }
                }
              },
              onStepTapped: (int step) {
                if (_formKey.currentState!.validate()) {
                  setState(() => currentStep = step);
                }
              },
              steps: _getSteps(),
              controlsBuilder: (context, details) {
                final isLastStep = currentStep == _getSteps().length - 1;

                return Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: details.onStepContinue!,
                          child: Text(isLastStep ? 'Enviar' : 'Avançar')),
                      Utils.addHorizontalSpace(12),
                      if (currentStep != 0)
                        OutlinedButton(
                            onPressed: details.onStepCancel!,
                            child: const Text('Voltar')),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget buildCompleted() => const Center(
        child: Text(
          'Submissão Concluída!',
          style: TextStyle(fontSize: 24),
        ),
      );

  List<Step> _getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text('Informações Pessoais'),
          content: PersonalInformationForm(
            nameController: _nameController,
            birthdayController: _birthdayController,
            phoneController: _phoneController,
            emailController: _emailController,
            rgController: _rgController,
            cpfController: _cpfController,
            issuingAuthorityController: _issuingAuthorityController,
            careerController: _careerController,
            formKey: _formKey,
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text('Residência'),
          content: Container(),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text('Educação'),
          content: Container(),
        ),
        Step(
          isActive: currentStep >= 3,
          title: const Text('Informações Adicionais'),
          content: Container(),
        ),
      ];
}
