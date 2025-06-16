import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  final TextEditingController wordController;
  final ValueNotifier<int?> countNotifier;

  const ResultWidget({
    super.key,
    required this.wordController,
    required this.countNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: countNotifier,
      builder: (context, count, child) {
        return Text(
          count != null
              ? '"${wordController.text.trim().toUpperCase()}" aparece $count vezes'
              : 'Selecione um arquivo e digite uma palavra',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: count != null ? Colors.blue : Colors.black,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
