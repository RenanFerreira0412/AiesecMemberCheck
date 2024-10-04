import 'package:aiesecmembercheck/screens/external/components/additional_information_form.dart';
import 'package:aiesecmembercheck/screens/external/components/address_form.dart';
import 'package:aiesecmembercheck/screens/external/components/education_form.dart';
import 'package:aiesecmembercheck/screens/external/components/personal_information_form.dart';
import 'package:aiesecmembercheck/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
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

  // Informações pessoais
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _rgController = TextEditingController();
  final _cpfController = TextEditingController();
  final _issuingAuthorityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _careerController = TextEditingController();

  // Residência
  final _cepController = TextEditingController();
  final _addressController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressNumberController = TextEditingController();
  final _complementController = TextEditingController();

  // Escolaridade
  final _educationLevelController = TextEditingController();
  final _universityController = TextEditingController();
  final _semesterController = TextEditingController();
  final _courseController = TextEditingController();

  // Informações adicionais
  final _discoveryChannelController = TextEditingController();
  final _committeeController = TextEditingController();
  final _anotherExperienceController = TextEditingController();
  List<String> _selectedExperiences = [];
  List<PlatformFile> _selectedDocumentFiles = [];
  PlatformFile? _selectedPhoto;
  String? _photoName;

  // Form Keys
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _educationFormKey = GlobalKey<FormState>();
  final _additionalInfoFormKey = GlobalKey<FormState>();

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
    _cepController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _addressNumberController.dispose();
    _complementController.dispose();
    _educationLevelController.dispose();
    _universityController.dispose();
    _semesterController.dispose();
    _courseController.dispose();
    _discoveryChannelController.dispose();
    _committeeController.dispose();
    _anotherExperienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => context.go('/'),
          child: Image.asset(
            'assets/images/aiesec_logo.png',
            width: 200,
          ),
        ),
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

                if (isLastStep) {
                  // Lógica de submissão ao banco de dados
                  setState(() => isCompleted = true);
                  print('Submissão concluída');
                } else {
                  setState(() => currentStep += 1);
                }
              },
              onStepTapped: (int step) {
                setState(() => currentStep = step);
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
            formKey: _personalInfoFormKey,
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text('Residência'),
          content: AddressForm(
              cepController: _cepController,
              addressController: _addressController,
              neighborhoodController: _neighborhoodController,
              stateController: _stateController,
              cityController: _cityController,
              addressNumberController: _addressNumberController,
              complementController: _complementController,
              formKey: _addressFormKey),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text('Educação'),
          content: EducationForm(
              educationLevelController: _educationLevelController,
              universityController: _universityController,
              semesterController: _semesterController,
              courseController: _courseController,
              formKey: _educationFormKey),
        ),
        Step(
          isActive: currentStep >= 3,
          title: const Text('Informações Adicionais'),
          content: AdditionalInformationForm(
            discoveryChannelController: _discoveryChannelController,
            formKey: _additionalInfoFormKey,
            committeeController: _committeeController,
            fileName: _photoName,
            selectedFiles: _selectedDocumentFiles,
            anotherExperienceController: _anotherExperienceController,
            onExperienceSelectionChanged: selectingExperiences,
            onDocumentFilesSelection: uploadingIdentityDocuments,
            onPhotoSelection: uploadPhoto,
          ),
        ),
      ];

  void selectingExperiences(List<String> selectedExperiences) {
    setState(() {
      _selectedExperiences = selectedExperiences;
    });
  }

  Future<void> uploadingIdentityDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['pdf', 'png', 'jpeg', 'jpg'],
    );

    if (result != null) {
      setState(() {
        _selectedDocumentFiles = result.files;
      });
    }
  }

  Future<void> uploadPhoto() async {
    final photoSelected = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (photoSelected != null && photoSelected.files.isNotEmpty) {
      setState(() {
        _selectedPhoto = photoSelected.files.single;
        _photoName = _selectedPhoto?.name;
      });
    }
  }
}
