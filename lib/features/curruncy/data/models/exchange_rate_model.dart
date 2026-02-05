import 'package:flutter_currency_converter/features/currency/domain/entities/exchange_rate_entity.dart';

class ExchangeRateModel extends ExchangeRateEntity {
  const ExchangeRateModel({
    required String fromCurrency,
    required String toCurrency,
    required double rate,
  }) : super(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          rate: rate,
        );

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json, String from, String to) {
    final key = '${from}_${to}';
    return ExchangeRateModel(
      fromCurrency: from,
      toCurrency: to,
      rate: (json[key] as num).toDouble(),
    );
  }
}