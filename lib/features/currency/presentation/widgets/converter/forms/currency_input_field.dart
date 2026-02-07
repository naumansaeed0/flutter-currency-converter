import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';

class CurrencyInputField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isReadOnly;
  final String? displayAmount;

  const CurrencyInputField({
    super.key,
    this.controller,
    this.onChanged,
    this.isReadOnly = false,
    this.displayAmount,
  });

  @override
  Widget build(BuildContext context) {
    if (isReadOnly) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimens.base),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          displayAmount ?? '',
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        hintText: "0.00",
        contentPadding: const EdgeInsets.all(AppDimens.base),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}