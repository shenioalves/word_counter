import 'package:flutter/material.dart';

class WordInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? Function(String?) validator;
  final VoidCallback onSubmit;

  const WordInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.validator,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        labelText: 'Qual palavra você quer contar?',
        labelStyle: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onFieldSubmitted: (_) => onSubmit(),
    );
  }
}
