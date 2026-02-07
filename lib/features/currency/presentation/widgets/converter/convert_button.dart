import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';

class ConvertButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConvertButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.base),
        child: const Text("CONVERT NOW"),
      ),
    );
  }
}