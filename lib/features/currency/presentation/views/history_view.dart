import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';
import 'package:flutter_currency_converter/core/theme/app_theme.dart';
import 'package:flutter_currency_converter/core/utils/constants.dart';
import 'package:flutter_currency_converter/features/currency/presentation/widgets/common/toggle_button.dart'; // Ensure this import exists
import '../bloc/currency_bloc.dart';
import '../widgets/history/currency_chart.dart';
import '../widgets/history/currency_table.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  bool _showChart = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, state) {
        if (state.historyStatus == CurrencyStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.history.isEmpty) {
          return const Center(
            child: Text(
              "No historical data available",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final isUp = state.history.last.rate >= state.history.first.rate;
        final trendColor = isUp ? AppTheme.accentGreen : AppTheme.dangerRed;

        return Padding(
          padding: const EdgeInsets.all(AppDimens.base),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '7 Day Trend',
                    style: TextStyle(
                      fontSize: AppDimens.textTitle,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        ToggleButton(
                          icon: Icons.show_chart,
                          isActive: _showChart,
                          onTap: () => setState(() => _showChart = true),
                        ),
                        ToggleButton(
                          icon: Icons.table_rows,
                          isActive: !_showChart,
                          onTap: () => setState(() => _showChart = false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.base),

              Expanded(
                child: _showChart
                    ? CurrencyChart(
                  history: state.history,
                  color: trendColor,
                )
                    : CurrencyTable(
                  history: state.history,
                  fromCode: AppConstants.lockedCurrencySource,
                  toCode: AppConstants.lockedCurrencyTarget,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}