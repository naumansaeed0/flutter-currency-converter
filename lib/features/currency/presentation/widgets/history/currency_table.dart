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
      padding: const EdgeInsets.symmetric(vertical: AppDimens.base / 2),
      itemCount: sortedHistory.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppDimens.base / 2),
      itemBuilder: (context, index) {
        final entry = sortedHistory[index];
        final date = entry.date;
        final rate = entry.rate;

        double? diff;
        double? percentChange;
        if (index < sortedHistory.length - 1) {
          final prevDayRate = sortedHistory[index + 1].rate;
          diff = rate - prevDayRate;
          percentChange = (diff / prevDayRate) * 100;
        }

        final isPositive = (diff ?? 0) >= 0;
        final changeColor = isPositive ? AppTheme.accentGreen : AppTheme.dangerRed;

        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.base),
            child: Row(
              children: [
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.base / 2,
                    vertical: AppDimens.base,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('dd').format(date),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryBlue.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.base),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1 $fromCode',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${rate.toStringAsFixed(4)} $toCode',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (diff != null && percentChange != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.base / 2,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: changeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          color: changeColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${isPositive ? '+' : ''}${percentChange.toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: changeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${isPositive ? '+' : ''}${diff.toStringAsFixed(4)}',
                              style: TextStyle(
                                color: changeColor,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}