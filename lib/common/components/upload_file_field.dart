import 'package:aiesecmembercheck/utils/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadFileField extends StatefulWidget {
  final String title;
  final bool isMultipleFiles;
  final List<PlatformFile>? selectedFiles;
  final String? fileName;
  final void Function() onFileSelection;

  const UploadFileField({
    super.key,
    required this.title,
    required this.onFileSelection,
    required this.isMultipleFiles,
    this.selectedFiles,
    this.fileName,
  });

  @override
  State<UploadFileField> createState() => _UploadFileFieldState();
}

class _UploadFileFieldState extends State<UploadFileField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DottedBorder(
        padding: const EdgeInsets.all(10),
        color: Colors.grey,
        strokeWidth: 1,
        dashPattern: const [8, 4],
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: Theme.of(context).textTheme.labelLarge),
              Utils.addVerticalSpace(8),
              ElevatedButton.icon(
                onPressed: widget.onFileSelection,
                label: const Text('Adicionar arquivo'),
                icon: const Icon(Icons.file_upload_outlined),
              ),
              Utils.addVerticalSpace(8),
              if (widget.isMultipleFiles) ...[
                (widget.selectedFiles != null &&
                        widget.selectedFiles!.isNotEmpty)
                    ? ListView.builder(
                        shrinkWrap: true, // Ajusta a altura da lista
                        itemCount: widget.selectedFiles!.length,
                        itemBuilder: (context, index) {
                          final fileName = widget.selectedFiles![index].name;
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(fileName),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_rounded),
                                onPressed: () => removeSelectedFile(index),
                              ),
                            ),
                          );
                        },
                      )
                    : const Text('Nenhum arquivo selecionado...')
              ] else ...[
                Text(widget.fileName ?? 'Nenhum arquivo selecionado...')
              ]
            ],
          ),
        ),
      ),
    );
  }

  void removeSelectedFile(int index) {
    setState(() {
      widget.selectedFiles?.removeAt(index);
    });
  }
}
