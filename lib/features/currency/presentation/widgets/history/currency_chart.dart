import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';
import 'package:flutter_currency_converter/core/theme/app_theme.dart';
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

    final minRate = sortedHistory.map((e) => e.rate).reduce((a, b) => a < b ? a : b);
    final maxRate = sortedHistory.map((e) => e.rate).reduce((a, b) => a > b ? a : b);
    final range = maxRate - minRate;
    final padding = range * 0.1;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.base),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.base * 1.5),
        child: LineChart(
          LineChartData(
            minY: minRate - padding,
            maxY: maxRate + padding,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: range / 4,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.shade200,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  interval: range / 4,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(left: AppDimens.base / 2),
                      child: Text(
                        value.toStringAsFixed(4),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    );
                  },
                ),
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
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => AppTheme.primaryBlue,
                tooltipBorderRadius: BorderRadius.circular(8),
                tooltipPadding: const EdgeInsets.all(8),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    if (index >= 0 && index < sortedHistory.length) {
                      final entry = sortedHistory[index];
                      return LineTooltipItem(
                        '${DateFormat('MMM d').format(entry.date)}\n${entry.rate.toStringAsFixed(4)}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    }
                    return null;
                  }).toList();
                },
              ),
              touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
              handleBuiltInTouches: true,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: color,
                barWidth: 3.0,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: color,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.3),
                      color.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}