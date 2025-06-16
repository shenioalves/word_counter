import 'dart:io';

import 'package:desafio_tecnico/app/word_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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

  Future<void> _countWord() async {
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

  Future<void> _pickFileAndCount() async {
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
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFileUploadSection(),

              _buildWordInputSection(),

              _buildResultSection(),

              _buildCountButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploadSection() {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedFileNotifier,
      builder: (context, selectedFile, child) {
        return Column(
          children: [
            InkWell(
              onTap: _pickFileAndCount,
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
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedFile != null)
              Text(
                'Arquivo ${selectedFile}selecionado!',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildWordInputSection() {
    return TextFormField(
      controller: wordController,
      focusNode: _wordFocusNode,
      validator: _validateWord,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      decoration: const InputDecoration(
        labelText: 'Qual palavra você quer contar?',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onFieldSubmitted: (_) => _countWord(),
    );
  }

  Widget _buildResultSection() {
    return ValueListenableBuilder<int?>(
      valueListenable: countNotifier,
      builder: (context, count, child) {
        return Text(
          count != null
              ? '"${wordController.text.trim().toUpperCase()}" aparece $count vezes'
              : 'Selecione um arquivo e digite uma palavra',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: count != null ? Colors.blue : Colors.black,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }

  Widget _buildCountButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: isProcessingNotifier,
      builder: (context, isProcessing, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: isProcessing ? null : _countWord,
            child: isProcessing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'CONTAR',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
        );
      },
    );
  }
}
