import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';
import 'package:flutter_currency_converter/features/currency/presentation/bloc/currency_bloc.dart';
import 'package:flutter_currency_converter/features/currency/presentation/widgets/converter/convert_button.dart';
import 'package:flutter_currency_converter/features/currency/presentation/widgets/converter/currency_dropdown_row.dart';
import 'package:flutter_currency_converter/features/currency/presentation/widgets/converter/swap_button.dart';

class ConverterView extends StatefulWidget {
  const ConverterView({super.key});

  @override
  State<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<ConverterView> {
  final _controller = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    context.read<CurrencyBloc>().add(GetInitialDataEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _convert() {
    final amount = double.tryParse(_controller.text) ?? 0;
    context.read<CurrencyBloc>().add(ConvertCurrencyEvent(amount: amount));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, state) {
        if (state.currenciesStatus == CurrencyStatus.loading && state.currencies.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.base),
          child: Column(
            children: [

              CurrencyDropdownRow(
                label: 'From',
                selectedCode: state.fromCurrency,
                currencies: state.currencies,
                controller: _controller,
                onAmountChanged: (_) {

                },
                onCurrencyChanged: (val) {
                  if (val != null) {
                    context.read<CurrencyBloc>().add(SourceCurrencyChanged(val));
                  }
                },
              ),

              const SizedBox(height: AppDimens.base),

              SwapButton(
                onTap: () {
                  context.read<CurrencyBloc>().add(SwapCurrenciesEvent());
                },
              ),

              const SizedBox(height: AppDimens.base),

              CurrencyDropdownRow(
                label: 'To',
                selectedCode: state.toCurrency,
                currencies: state.currencies,
                isReadOnly: true,
                displayAmount: state.convertedAmount.toStringAsFixed(2),
                onCurrencyChanged: (val) {
                  if (val != null) {
                    context.read<CurrencyBloc>().add(TargetCurrencyChanged(val));
                  }
                },
              ),

              const SizedBox(height: AppDimens.base * 2),

              ConvertButton(onPressed: _convert),
            ],
          ),
        );
      },
    );
  }
}