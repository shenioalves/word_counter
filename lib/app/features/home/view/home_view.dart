import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../controller/word_count.dart';
import '../widget/count_button_widget.dart';
import '../widget/file_upload_widget.dart';
import '../widget/result_widget.dart';
import '../widget/word_input_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ValueNotifier<bool> isProcessingNotifier = ValueNotifier(false);
  final ValueNotifier<int?> countNotifier = ValueNotifier(null);
  final ValueNotifier<String?> selectedFileNotifier = ValueNotifier(null);
  final ValueNotifier<List<List<String>>> matrixNotifier = ValueNotifier([]);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController wordController = TextEditingController();
  final FocusNode _wordFocusNode = FocusNode();

  @override
  void dispose() {
    isProcessingNotifier.dispose();
    countNotifier.dispose();
    selectedFileNotifier.dispose();
    matrixNotifier.dispose();
    wordController.dispose();
    _wordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _wordCount() async {
    if (!_formKey.currentState!.validate()) return;
    if (matrixNotifier.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um arquivo primeiro'),
        ),
      );
      return;
    }

    isProcessingNotifier.value = true;

    try {
      final word = wordController.text.trim().toUpperCase();
      final result = countWord(matrixNotifier.value, word);

      countNotifier.value = result;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao processar: ${e.toString()}')),
      );
    } finally {
      isProcessingNotifier.value = false;
    }
  }

  String? _validateWord(String? value) {
    final word = value?.trim() ?? '';

    if (word.isEmpty) {
      return 'Por favor, insira uma palavra';
    }

    return null;
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        allowMultiple: false,
        dialogTitle: 'Selecione um arquivo de texto',
      );

      if (result != null) {
        final path = result.files.single.path;

        if (path == null || !path.endsWith('.txt')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Por favor, selecione um arquivo .txt válido'),
            ),
          );
          return;
        }

        final file = File(path);
        final lines = await file.readAsLines();

        matrixNotifier.value = lines
            .map((line) => line.toUpperCase().split(''))
            .toList();
        selectedFileNotifier.value = result.files.single.name;

        countNotifier.value = null;
      }
    } catch (e) {
      debugPrint('Erro ao ler o arquivo: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contador de palavras',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 30,
              children: [
                FileUploadWidget(
                  selectedFileNotifier: selectedFileNotifier,
                  onPickFile: _pickFile,
                ),

                WordInputWidget(
                  controller: wordController,
                  focusNode: _wordFocusNode,
                  validator: _validateWord,
                  onSubmit: _wordCount,
                ),

                ResultWidget(
                  wordController: wordController,
                  countNotifier: countNotifier,
                ),
                CountButtonWidget(
                  onPressed: _wordCount,
                  isProcessingNotifier: isProcessingNotifier,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
