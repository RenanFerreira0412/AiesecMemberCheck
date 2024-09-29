import 'package:flutter/material.dart';

class SelectionField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final List<String> items;

  const SelectionField(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      this.validator,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: controller.text.isEmpty
            ? null
            : controller.text, // Definindo o valor inicial
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String? newValue) {
          controller.text = newValue ?? ''; // Atualizando o controlador
        },
        validator: validator,
      ),
    );
  }
}
