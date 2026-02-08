import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';
import 'package:flutter_currency_converter/core/theme/app_theme.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/historical_rate_entity.dart';

class CurrencySummary extends StatelessWidget {
  final List<HistoricalRateEntity> history;
  final String toCode;

  const CurrencySummary({
    super.key,
    required this.history,
    required this.toCode,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox();

    final rates = history.map((e) => e.rate).toList();
    final minRate = rates.reduce((a, b) => a < b ? a : b);
    final maxRate = rates.reduce((a, b) => a > b ? a : b);
    final avgRate = rates.reduce((a, b) => a + b) / rates.length;
    
    final sortedHistory = List<HistoricalRateEntity>.from(history)
      ..sort((a, b) => a.date.compareTo(b.date));
    
    final startRate = sortedHistory.first.rate;
    final endRate = sortedHistory.last.rate;
    final change = endRate - startRate;
    final percentChange = (change / startRate) * 100;
    final isPositive = change >= 0;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppDimens.base),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.base, 
          horizontal: AppDimens.base / 2
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Min', minRate, toCode, Colors.grey.shade700),
            _buildVerticalDivider(),
            _buildStatItem('Max', maxRate, toCode, Colors.grey.shade700),
            _buildVerticalDivider(),
            _buildStatItem('Avg', avgRate, toCode, Colors.grey.shade700),
            _buildVerticalDivider(),
             _buildChangeItem(percentChange, isPositive),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildStatItem(String label, double value, String unit, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(4),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildChangeItem(double percent, bool isPositive) {
    final color = isPositive ? AppTheme.accentGreen : AppTheme.dangerRed;
    return Column(
      children: [
        Text(
          'Change',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPositive ? Icons.arrow_upward : Icons.arrow_downward,
              size: 12,
              color: color,
            ),
            const SizedBox(width: 2),
            Text(
              '${percent.abs().toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
