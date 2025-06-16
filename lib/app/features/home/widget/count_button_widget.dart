import 'package:flutter/material.dart';

class CountButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final ValueNotifier<bool> isProcessingNotifier;

  const CountButtonWidget({
    super.key,
    required this.onPressed,
    required this.isProcessingNotifier,
  });

  @override
  Widget build(BuildContext context) {
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
            onPressed: isProcessing ? null : onPressed,
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
