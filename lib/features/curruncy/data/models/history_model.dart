import 'package:hive/hive.dart';

part 'history_model.g.dart';

@HiveType(typeId: 1)
class HistoryModel {
  @HiveField(0)
  final String from;

  @HiveField(1)
  final String to;

  @HiveField(2)
  final Map<String, double> rates;

  @HiveField(3)
  final String lastUpdated;

  HistoryModel({
    required this.from,
    required this.to,
    required this.rates,
    required this.lastUpdated,
  });
}