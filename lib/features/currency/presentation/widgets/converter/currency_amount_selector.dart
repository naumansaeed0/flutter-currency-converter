import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:flutter_currency_converter/features/currency/presentation/widgets/converter/forms/currency_input_field.dart';
import 'package:flutter_currency_converter/features/currency/presentation/widgets/converter/forms/searchable_currency_picker.dart';

class CurrencyAmountSelector extends StatelessWidget {
  final String label;
  final String selectedCode;
  final List<CurrencyEntity> currencies;
  final ValueChanged<String?> onCurrencyChanged;
  final TextEditingController? controller;
  final ValueChanged<String>? onAmountChanged;
  final bool isReadOnly;
  final String? displayAmount;

  const CurrencyAmountSelector({
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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimens.base / 2),

        SearchableCurrencyPicker(
          selectedCode: selectedCode,
          currencies: currencies,
          onChanged: onCurrencyChanged,
        ),

        const SizedBox(height: AppDimens.base),

        Text(
          'Amount',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimens.base / 2),

        CurrencyInputField(
          controller: controller,
          onChanged: onAmountChanged,
          isReadOnly: isReadOnly,
          displayAmount: displayAmount,
        ),
      ],
    );
  }
}
