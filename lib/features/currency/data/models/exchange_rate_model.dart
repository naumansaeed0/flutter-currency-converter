import '../../domain/entities/exchange_rate_entity.dart';

class ExchangeRateModel extends ExchangeRateEntity {
  const ExchangeRateModel({
    required super.fromCurrency,
    required super.toCurrency,
    required super.rate,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json, String from, String to) {
    final key = '${from}_$to';
    return ExchangeRateModel(
      fromCurrency: from,
      toCurrency: to,
      rate: (json[key] as num).toDouble(),
    );
  }

  factory ExchangeRateModel.fromUniRateJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      fromCurrency: json['from'] as String,
      toCurrency: json['to'] as String,
      rate: (json['rate'] as num).toDouble(),
    );
  }
}