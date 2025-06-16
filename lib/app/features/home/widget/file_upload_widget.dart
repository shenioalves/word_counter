import 'package:flutter/material.dart';

class FileUploadWidget extends StatelessWidget {
  final ValueNotifier<String?> selectedFileNotifier;
  final VoidCallback onPickFile;

  const FileUploadWidget({
    super.key,
    required this.selectedFileNotifier,
    required this.onPickFile,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedFileNotifier,
      builder: (context, selectedFile, child) {
        return Column(
          children: [
            InkWell(
              onTap: onPickFile,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(20),
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.file_upload_outlined, size: 40),
                    Text(
                      selectedFile ?? 'Selecionar arquivo',
                    ),
                  ],
                ),
              ),
            ),
            if (selectedFile != null)
              Text(
                'Arquivo $selectedFile selecionado!',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        );
      },
    );
  }
}
