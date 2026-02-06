import 'package:dio/dio.dart';
import 'package:flutter_currency_converter/core/error/exceptions.dart';
import 'package:flutter_currency_converter/core/utils/constants.dart';
import 'package:flutter_currency_converter/features/currency/data/models/currency_model.dart';
import 'package:flutter_currency_converter/features/currency/data/models/exchange_rate_model.dart';
import 'package:injectable/injectable.dart';


abstract class CurrencyRemoteDataSource {
  Future<List<CurrencyModel>> getCurrencies();
  Future<ExchangeRateModel> getExchangeRate(String from, String to);
  Future<Map<String, double>> getHistoricalRates(String from, String to, String startDate, String endDate);
}

@LazySingleton(as: CurrencyRemoteDataSource)
class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final Dio dio;

  CurrencyRemoteDataSourceImpl({required this.dio});



  @override
  Future<List<CurrencyModel>> getCurrencies() async {
    final url = '${AppConstants.baseUrl}${AppConstants.currenciesEndpoint}';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final jsonMap = response.data;

        if (jsonMap is Map && jsonMap.containsKey('results')) {
          final results = jsonMap['results'] as Map<String, dynamic>;
          return results.values
              .map((e) => CurrencyModel.fromJson(e))
              .toList()
            ..sort((a, b) => a.code.compareTo(b.code));
        } else {
          throw ServerException();
        }
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<ExchangeRateModel> getExchangeRate(String from, String to) async {
    final query = '${from}_$to';
    final url = '${AppConstants.baseUrl}${AppConstants.convertEndpoint}?q=$query&compact=ultra';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final jsonMap = response.data;

        if (jsonMap is Map && jsonMap.containsKey(query)) {
          final rate = (jsonMap[query] as num).toDouble();
          return ExchangeRateModel(
            fromCurrency: from,
            toCurrency: to,
            rate: rate,
          );
        } else {
          throw ServerException();
        }
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, double>> getHistoricalRates(String from, String to, String startDate, String endDate) async {
    final query = '${from}_$to';
    final url = '${AppConstants.baseUrl}${AppConstants.convertEndpoint}?q=$query&compact=ultra&date=$startDate&endDate=$endDate';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final jsonMap = response.data;

        if (jsonMap is Map && jsonMap.containsKey(query)) {
          final ratesMap = jsonMap[query];

          if (ratesMap is Map) {
            return Map<String, double>.from(
                ratesMap.map((key, value) => MapEntry(key, (value as num).toDouble()))
            );
          }
        }
        throw ServerException();
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }
}