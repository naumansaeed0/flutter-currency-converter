import 'package:flutter/material.dart';

class CurrencyLabel extends StatelessWidget {
  final String label;
  const CurrencyLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)
    );
  }
}