import 'package:equatable/equatable.dart';

class HistoricalRateEntity extends Equatable {
  final DateTime date;
  final double rate;

  const HistoricalRateEntity({
    required this.date,
    required this.rate,
  });

  @override
  List<Object> get props => [date, rate];
}