import 'package:flutter/material.dart';
import 'package:aiesecmembercheck/common/components/editor.dart';
import 'package:aiesecmembercheck/models/address.dart';
import 'package:aiesecmembercheck/services/api_service.dart';
import 'package:aiesecmembercheck/utils/device_helper.dart';
import 'package:aiesecmembercheck/utils/utils.dart';
import 'package:aiesecmembercheck/validators/field_validator.dart';

class AddressForm extends StatefulWidget {
  final TextEditingController cepController;
  final TextEditingController addressController;
  final TextEditingController neighborhoodController;
  final TextEditingController stateController;
  final TextEditingController cityController;
  final TextEditingController addressNumberController;
  final TextEditingController complementController;
  final GlobalKey<FormState> formKey;

  const AddressForm({
    super.key,
    required this.cepController,
    required this.addressController,
    required this.neighborhoodController,
    required this.stateController,
    required this.cityController,
    required this.addressNumberController,
    required this.complementController,
    required this.formKey,
  });

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final ApiService service = ApiService();
  bool readOnly = true;

  @override
  void initState() {
    super.initState();
    _setAddressAutocomplete();
  }

  /// Configura o preenchimento automático dos campos com base no CEP informado.
  void _setAddressAutocomplete() {
    widget.cepController.addListener(_cepListener);
  }

  /// Listener que escuta mudanças no campo de CEP.
  void _cepListener() {
    if (widget.cepController.text.length == 9) {
      _updateAddressFields();
    }
  }

  /// Atualiza os campos de endereço com base no CEP informado.
  Future<void> _updateAddressFields() async {
    try {
      final url = "https://viacep.com.br/ws/${widget.cepController.text}/json/";
      final data = await service.fetchData(url);

      final address = Address(
        cep: data!['cep'],
        street: data['logradouro'],
        complement: data['complemento'],
        neighborhood: data['bairro'],
        city: data['localidade'],
        state: data['uf'],
      );

      setState(() {
        widget.addressController.text = address.street;
        widget.neighborhoodController.text = address.neighborhood;
        widget.stateController.text = address.state;
        widget.cityController.text = address.city;
        readOnly = false;
      });
    } catch (e) {
      Utils.showSnackBar('CEP inválido!');
      _clearAddressFields();
    }
  }

  /// Limpa os campos de endereço caso o CEP seja inválido.
  void _clearAddressFields() {
    widget.addressController.clear();
    widget.neighborhoodController.clear();
    widget.stateController.clear();
    widget.cityController.clear();
    setState(() {
      readOnly = true;
    });
  }

  // Função que retorna a lista de campos do formulário
  List<Widget> _buildFormFields() {
    return [
      Editor(
        controller: widget.cepController,
        label: 'CEP',
        hint: 'CEP do seu endereço',
        obscureText: false,
        keyboardType: TextInputType.number,
        mask: "#####-###",
        validator: (value) => FieldValidator.validateRequired(value, 'CEP'),
      ),
      Editor(
        controller: widget.addressController,
        label: 'Endereço',
        hint: 'Seu endereço',
        obscureText: false,
        readOnly: readOnly,
        keyboardType: TextInputType.text,
        validator: (value) =>
            FieldValidator.validateRequired(value, 'Endereço'),
      ),
      Editor(
        controller: widget.neighborhoodController,
        label: 'Bairro',
        hint: 'Seu bairro',
        obscureText: false,
        readOnly: readOnly,
        keyboardType: TextInputType.text,
        validator: (value) => FieldValidator.validateRequired(value, 'Bairro'),
      ),
      Editor(
        controller: widget.stateController,
        label: 'Estado',
        hint: 'Seu estado',
        obscureText: false,
        readOnly: readOnly,
        keyboardType: TextInputType.text,
        validator: (value) => FieldValidator.validateRequired(value, 'Estado'),
      ),
      Editor(
        controller: widget.cityController,
        label: 'Cidade',
        hint: 'Sua cidade',
        obscureText: false,
        readOnly: readOnly,
        keyboardType: TextInputType.text,
        validator: (value) => FieldValidator.validateRequired(value, 'Cidade'),
      ),
      Editor(
        controller: widget.addressNumberController,
        label: 'Número',
        hint: 'Ex: 83',
        obscureText: false,
        keyboardType: TextInputType.number,
        validator: (value) => FieldValidator.validateRequired(value, 'Número'),
      ),
      Editor(
        controller: widget.complementController,
        label: 'Complemento',
        hint: 'Complemento (ex.: Apto. 110, Bloco F)',
        obscureText: false,
        keyboardType: TextInputType.text,
        validator: (value) =>
            FieldValidator.validateRequired(value, 'Complemento'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = DeviceHelper.isDesktop(context);
    const double spacing = 16.0;
    final fields = _buildFormFields();

    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
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
