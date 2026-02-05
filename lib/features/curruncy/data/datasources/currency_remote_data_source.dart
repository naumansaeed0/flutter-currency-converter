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

  CurrencyRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CurrencyModel>> getCurrencies() async {
    try {
      final response = await dio.get(AppConstants.currenciesEndpoint);

      final results = response.data['results'] as Map<String, dynamic>;

      return results.values
          .map((e) => CurrencyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ExchangeRateModel> getExchangeRate(String from, String to) async {
    try {
      final q = '${from}_${to}';
      final response = await dio.get(
        AppConstants.convertEndpoint,
        queryParameters: {'q': q, 'compact': 'ultra'},
      );

      return ExchangeRateModel.fromJson(response.data, from, to);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, double>> getHistoricalRates(String from, String to, String startDate, String endDate) async {
    try {
      final q = '${from}_${to}';

      final response = await dio.get(
        AppConstants.convertEndpoint,
        queryParameters: {
          'q': q,
          'compact': 'ultra',
          'date': startDate,
          'endDate': endDate
        },
      );

      final data = response.data[q] as Map<String, dynamic>;

      return data.map((key, value) => MapEntry(key, (value as num).toDouble()));

    } catch (e) {
      throw ServerException();
    }
  }
}