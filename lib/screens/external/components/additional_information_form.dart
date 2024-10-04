import 'package:aiesecmembercheck/common/components/editor.dart';
import 'package:aiesecmembercheck/common/components/selection_field.dart';
import 'package:aiesecmembercheck/common/components/upload_file_field.dart';
import 'package:aiesecmembercheck/models/experience.dart';
import 'package:aiesecmembercheck/repository/discovery_channels_aiesec_repository.dart';
import 'package:aiesecmembercheck/repository/experience_repository.dart';
import 'package:aiesecmembercheck/services/local_committees_service.dart';
import 'package:aiesecmembercheck/utils/utils.dart';
import 'package:aiesecmembercheck/validators/field_validator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AdditionalInformationForm extends StatefulWidget {
  final TextEditingController discoveryChannelController;
  final TextEditingController committeeController;
  final TextEditingController anotherExperienceController;
  final GlobalKey<FormState> formKey;
  final String? fileName;
  final List<PlatformFile>? selectedFiles;
  final void Function() onPhotoSelection;
  final void Function() onDocumentFilesSelection;
  final void Function(List<String>) onExperienceSelectionChanged;

  const AdditionalInformationForm(
      {super.key,
      required this.discoveryChannelController,
      required this.formKey,
      required this.committeeController,
      required this.onExperienceSelectionChanged,
      required this.anotherExperienceController,
      this.fileName,
      this.selectedFiles,
      required this.onPhotoSelection,
      required this.onDocumentFilesSelection});

  @override
  State<AdditionalInformationForm> createState() =>
      _AdditionalInformationFormState();
}

class _AdditionalInformationFormState extends State<AdditionalInformationForm> {
  final LocalCommitteeService _committeeService = LocalCommitteeService();
  List<String> _committees = [];

  final List<String> _discoveryChannelsAiesec =
      DiscoveryChannelsAiesecRepository.discoveryChannelsAIESEC;
  final List<Experience> _experiences = ExperienceRepository.experiences;
  final List<String> _selectedExperiences = [];

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

  // Função que retorna a lista de campos do formulário
  List<Widget> _buildFormFields() {
    return [
      SelectionField(
        controller: widget.discoveryChannelController,
        label: 'Como você conheceu a AIESEC?',
        hint: 'Escolha o meio pelo qual descobriu a AIESEC',
        items: _discoveryChannelsAiesec,
        validator: (value) => FieldValidator.validateRequired(
            value, 'Como você conheceu a AIESEC?'),
      ),
      SelectionField(
          controller: widget.committeeController,
          label: 'Comitê Local',
          hint: 'Selecione um comitê',
          items: _committees,
          validator: (value) =>
              FieldValidator.validateRequired(value, 'Comitê Local')),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: DottedBorder(
          padding: const EdgeInsets.all(10),
          color: Colors.grey,
          strokeWidth: 1,
          dashPattern: const [8, 4],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Qual dessas experiências você tem?',
                  style: Theme.of(context).textTheme.labelLarge),
              const Text('Selecione todas as opções que se aplicam a você'),
              Utils.addVerticalSpace(8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _experiences.length,
                itemBuilder: (context, index) {
                  final experience = _experiences[index];

                  return CheckboxListTile(
                    checkColor: Colors.white,
                    value: experience.isChecked,
                    title: Text(experience.title),
                    onChanged: (bool? value) {
                      setState(() {
                        experience.toggleCheck();

                        if (experience.isChecked) {
                          _selectedExperiences.add(experience.title);
                        } else {
                          _selectedExperiences.remove(experience.title);
                        }

                        widget
                            .onExperienceSelectionChanged(_selectedExperiences);
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      if (_selectedExperiences.contains('Outro')) ...[
        Editor(
          controller: widget.anotherExperienceController,
          label: 'Outra Experiência',
          hint: 'Informe uma outra experiência que você teve.',
          obscureText: false,
          keyboardType: TextInputType.text,
        ),
      ],
      UploadFileField(
          title:
              'Insira uma foto do documento com foto, contendo CPF e RG, frente e verso.',
          selectedFiles: widget.selectedFiles,
          onFileSelection: widget.onDocumentFilesSelection,
          isMultipleFiles: true),
      UploadFileField(
          title: 'Anexe uma foto sua de que você goste.',
          fileName: widget.fileName,
          onFileSelection: widget.onPhotoSelection,
          isMultipleFiles: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final fields = _buildFormFields();

    return SingleChildScrollView(
      child: Form(key: widget.formKey, child: Column(children: fields)),
    );
  }
}
