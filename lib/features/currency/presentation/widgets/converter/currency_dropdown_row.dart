import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:flutter_currency_converter/features/currency/presentation/widgets/converter/forms/currency_input_field.dart';
import 'package:flutter_currency_converter/features/currency/presentation/widgets/converter/forms/currency_picker.dart';

class CurrencyDropdownRow extends StatelessWidget {
  final String label;
  final String selectedCode;
  final List<CurrencyEntity> currencies;
  final ValueChanged<String?> onCurrencyChanged;
  final TextEditingController? controller;
  final ValueChanged<String>? onAmountChanged;
  final bool isReadOnly;
  final String? displayAmount;

  const CurrencyDropdownRow({
    super.key,
    required this.label,
    required this.selectedCode,
    required this.currencies,
    required this.onCurrencyChanged,
    this.controller,
    this.onAmountChanged,
    this.isReadOnly = false,
    this.displayAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: AppDimens.base / 2),
        Row(
          children: [
            CurrencyPicker(
              selectedCode: selectedCode,
              currencies: currencies,
              onChanged: onCurrencyChanged,
            ),
            const SizedBox(width: AppDimens.base),
            Expanded(
              // Uses the UPDATED CurrencyInputField
              child: CurrencyInputField(
                controller: controller,
                onChanged: onAmountChanged,
                isReadOnly: isReadOnly,
                displayAmount: displayAmount,
              ),
            ),
          ],
        ),
      ],
    );
  }
}