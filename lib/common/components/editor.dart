import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Editor extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLines;
  final String? mask; // Tornando o campo mask opcional

  const Editor({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    required this.obscureText,
    required this.keyboardType,
    this.maxLines = 1, // Valor padrão para maxLines
    this.mask, // Máscara opcional
  });

  @override
  EditorState createState() => EditorState();
}

class EditorState extends State<Editor> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText; // Inicializa a visibilidade da senha
  }

  @override
  Widget build(BuildContext context) {
    // Inicializa a formatação da máscara, se fornecida
    var maskFormatter =
        widget.mask != null ? MaskTextInputFormatter(mask: widget.mask!) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          helperText: widget.hint, // Dica para o usuário
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure; // Alterna a visibilidade
                    });
                  },
                )
              : null,
        ),
        validator: widget.validator,
        obscureText: _isObscure,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        inputFormatters: maskFormatter != null
            ? [maskFormatter]
            : [], // Adiciona a máscara se disponível
      ),
    );
  }
}
