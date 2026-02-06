import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/historical_rate_entity.dart';

class CurrencyChart extends StatelessWidget {
  final List<HistoricalRateEntity> history;
  final Color color;

  const CurrencyChart({
    super.key,
    required this.history,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final sortedHistory = List<HistoricalRateEntity>.from(history)
      ..sort((a, b) => a.date.compareTo(b.date));

    final spots = sortedHistory.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.rate);
    }).toList();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.base * 1.5),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40)
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < sortedHistory.length) {
                      final date = sortedHistory[index].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: AppDimens.base / 2),
                        child: Text(
                            DateFormat('d MMM').format(date),
                            style: const TextStyle(fontSize: 10)
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: color,
                barWidth: 4.0,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}