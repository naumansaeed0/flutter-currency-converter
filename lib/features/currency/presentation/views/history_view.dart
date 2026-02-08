import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';
import 'package:flutter_currency_converter/core/theme/app_theme.dart';
import 'package:flutter_currency_converter/core/utils/constants.dart';
import 'package:flutter_currency_converter/features/currency/presentation/widgets/common/toggle_button.dart';
import 'package:flutter_currency_converter/features/currency/presentation/widgets/history/currency_summary.dart';
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_toggle_off, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  "No historical data available",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        final isUp = state.history.last.rate >= state.history.first.rate;
        final trendColor = isUp ? AppTheme.accentGreen : AppTheme.dangerRed;

        return Padding(
          padding: const EdgeInsets.all(AppDimens.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Market Trend',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      Text(
                        'Last 7 Days',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ToggleButton(
                          icon: Icons.show_chart,
                          isActive: _showChart,
                          onTap: () => setState(() => _showChart = true),
                        ),
                        ToggleButton(
                          icon: Icons.list_alt,
                          isActive: !_showChart,
                          onTap: () => setState(() => _showChart = false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.base),

              CurrencySummary(
                history: state.history,
                toCode: AppConstants.lockedCurrencyTarget,
              ),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _showChart
                      ? CurrencyChart(
                          key: const ValueKey('chart'),
                          history: state.history,
                          color: trendColor,
                        )
                      : CurrencyTable(
                          key: const ValueKey('table'),
                          history: state.history,
                          fromCode: AppConstants.lockedCurrencySource,
                          toCode: AppConstants.lockedCurrencyTarget,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}