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
  final Dio historicalDio;

  CurrencyRemoteDataSourceImpl({
    required this.dio,
    @Named('historicalDio') required this.historicalDio,
  });


  @override
  Future<List<CurrencyModel>> getCurrencies() async {
    final url = '${AppConstants.baseUrl}${AppConstants.currenciesEndpoint}';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final jsonMap = response.data as Map<String, dynamic>;

        if (jsonMap.containsKey('currencies')) {
          final currenciesData = jsonMap['currencies'];
          
          if (currenciesData is List) {
            return currenciesData
                .map((code) {
                  final currencyCode = code.toString();
                  return CurrencyModel.fromCodeAndName(currencyCode, currencyCode);
                })
                .toList()
              ..sort((a, b) => a.code.compareTo(b.code));
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

  @override
  Future<ExchangeRateModel> getExchangeRate(String from, String to) async {
    final url = '${AppConstants.baseUrl}${AppConstants.convertEndpoint}?from=$from&to=$to';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final jsonMap = response.data as Map<String, dynamic>;

        if (jsonMap.containsKey('result')) {
          return ExchangeRateModel(
            fromCurrency: jsonMap['from'] as String,
            toCurrency: jsonMap['to'] as String,
            rate: (jsonMap['result'] as num).toDouble(),
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
    final url = '${AppConstants.historicalTimeseriesPath}?start_date=$startDate&end_date=$endDate&base=$from&symbols=$to';
    
    try {
      final response = await historicalDio.get(url);

      if (response.statusCode == 200) {
        final jsonMap = response.data as Map<String, dynamic>;

        if (jsonMap.containsKey('quotes')) {
          final quotesMap = jsonMap['quotes'] as Map<String, dynamic>;
          
          final result = <String, double>{};
          final currencyPairKey = '$from$to';
          
          quotesMap.forEach((date, currencies) {
            if (currencies is Map && currencies.containsKey(currencyPairKey)) {
              result[date] = (currencies[currencyPairKey] as num).toDouble();
            }
          });
          
          return result;
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