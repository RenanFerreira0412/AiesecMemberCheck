import 'package:aiesecmembercheck/common/components/editor.dart';
import 'package:aiesecmembercheck/common/components/selection_field.dart';
import 'package:aiesecmembercheck/repository/course_repository.dart';
import 'package:aiesecmembercheck/repository/education_repository.dart';
import 'package:aiesecmembercheck/utils/device_helper.dart';
import 'package:aiesecmembercheck/utils/utils.dart';
import 'package:aiesecmembercheck/validators/field_validator.dart';
import 'package:flutter/material.dart';

class EducationForm extends StatelessWidget {
  final TextEditingController educationLevelController;
  final TextEditingController courseController;
  final TextEditingController universityController;
  final TextEditingController semesterController;
  final GlobalKey<FormState> formKey;

  EducationForm(
      {super.key,
      required this.educationLevelController,
      required this.universityController,
      required this.semesterController,
      required this.courseController,
      required this.formKey});

  final List<String> _educationLevels = EducationRepository.educationLevels;
  final List<String> _courses = CourseRepository.courses;
  final List<String> _semesters = EducationRepository.semesters;

  // Função que retorna a lista de campos do formulário
  List<Widget> _buildFormFields() {
    return [
      SelectionField(
          controller: educationLevelController,
          label: 'Escolaridade',
          hint: 'Seu grau de escolaridade',
          items: _educationLevels,
          validator: (value) =>
              FieldValidator.validateRequired(value, 'Escolaridade')),
      SelectionField(
          controller: courseController,
          label: 'Curso',
          hint:
              'Seu curso de formação ou o curso que está cursando. Se não tiver cursado nenhum, responda "Nenhum"',
          items: _courses,
          validator: (value) =>
              FieldValidator.validateRequired(value, 'Curso')),
      Editor(
        controller: universityController,
        label: 'Universidade',
        hint:
            'Sua universidade (ex.: UFSC). Caso não esteja matriculado em nenhuma, responda "Nenhuma".',
        obscureText: false,
        keyboardType: TextInputType.text,
        validator: (value) =>
            FieldValidator.validateRequired(value, 'Universidade'),
      ),
      SelectionField(
          controller: semesterController,
          label: 'Semestre',
          hint:
              'Semestre atual (ex.: 5º semestre). Se você não estiver cursando nenhum curso ou já tiver concluído, responda "Nenhum".',
          items: _semesters,
          validator: (value) =>
              FieldValidator.validateRequired(value, 'Semestre')),
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
