import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';
import 'package:flutter_currency_converter/core/theme/app_theme.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/historical_rate_entity.dart';

class CurrencyTable extends StatelessWidget {
  final List<HistoricalRateEntity> history;
  final String fromCode;
  final String toCode;

  const CurrencyTable({
    super.key,
    required this.history,
    required this.fromCode,
    required this.toCode,
  });

  @override
  Widget build(BuildContext context) {
    final sortedHistory = List<HistoricalRateEntity>.from(history)
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView.separated(
      itemCount: sortedHistory.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final entry = sortedHistory[index];
        final date = entry.date;
        final rate = entry.rate;

        double? diff;
        if (index < sortedHistory.length - 1) {
          final prevDayRate = sortedHistory[index + 1].rate;
          diff = rate - prevDayRate;
        }

        final isPositive = (diff ?? 0) >= 0;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: AppDimens.base / 2),
          leading: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              DateFormat('dd\nMMM').format(date),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue
              ),
            ),
          ),
          title: Text(
              "1 $fromCode = ${rate.toStringAsFixed(4)} $toCode",
              style: const TextStyle(fontWeight: FontWeight.bold)
          ),
          trailing: diff == null
              ? const SizedBox()
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                diff.abs().toStringAsFixed(4),
                style: TextStyle(
                    color: isPositive ? AppTheme.accentGreen : AppTheme.dangerRed
                ),
              ),
              Icon(
                isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: isPositive ? AppTheme.accentGreen : AppTheme.dangerRed,
              ),
            ],
          ),
        );
      },
    );
  }
}