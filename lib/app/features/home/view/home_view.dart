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
  final ValueNotifier<List<List<String>>> matrizNotifier = ValueNotifier([]);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController wordController = TextEditingController();
  final FocusNode _wordFocusNode = FocusNode();

  @override
  void dispose() {
    isProcessingNotifier.dispose();
    countNotifier.dispose();
    selectedFileNotifier.dispose();
    matrizNotifier.dispose();
    wordController.dispose();
    _wordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _wordCount() async {
    if (!_formKey.currentState!.validate()) return;
    if (matrizNotifier.value.isEmpty) {
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
      final result = countWord(matrizNotifier.value, word);

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
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);
      final lines = await file.readAsLines();

      matrizNotifier.value = lines
          .map((line) => line.toUpperCase().split(''))
          .toList();
      selectedFileNotifier.value = result.files.single.name;

      countNotifier.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contador de palavras',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
