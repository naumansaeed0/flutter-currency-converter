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
}