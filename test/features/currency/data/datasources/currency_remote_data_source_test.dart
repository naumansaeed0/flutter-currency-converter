import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_currency_converter/core/error/exceptions.dart';
import 'package:flutter_currency_converter/features/currency/data/datasources/currency_remote_data_source.dart';
import 'package:flutter_currency_converter/features/currency/data/models/currency_model.dart';
import 'package:flutter_currency_converter/features/currency/data/models/exchange_rate_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_helper.dart';

void main() {
  late CurrencyRemoteDataSourceImpl dataSource;
  late MockDio mockDio;
  late MockDio mockHistoricalDio;

  setUp(() {
    mockDio = MockDio();
    mockHistoricalDio = MockDio();
    dataSource = CurrencyRemoteDataSourceImpl(
      dio: mockDio,
      historicalDio: mockHistoricalDio,
    );
  });

  group('getCurrencies', () {
    test('should return list of CurrencyModel when response is 200', () async {
      final responsePayload = jsonEncode({
        "currencies": ["USD", "EUR"]
      });

      when(() => mockDio.get(any())).thenAnswer(
            (_) async => Response(
          data: jsonDecode(responsePayload),
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getCurrencies();

      expect(result, isA<List<CurrencyModel>>());
      expect(result.length, 2);
      expect(result.first.code, 'EUR');
      expect(result.first.name, 'EUR'); // Since name assumes code
    });

    test('should throw ServerException when response code is not 200', () async {
      when(() => mockDio.get(any())).thenAnswer(
            (_) async => Response(
          data: 'Something went wrong',
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final call = dataSource.getCurrencies;

      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });

  group('getExchangeRate', () {
    const tFrom = 'USD';
    const tTo = 'EUR';
    final tExchangeRateModel = ExchangeRateModel(fromCurrency: tFrom, toCurrency: tTo, rate: 0.85);

    test('should return ExchangeRateModel when response is 200', () async {
      final responsePayload = jsonEncode({
        "from": "USD",
        "to": "EUR",
        "result": 0.85
      });

      when(() => mockDio.get(any())).thenAnswer(
            (_) async => Response(
          data: jsonDecode(responsePayload),
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getExchangeRate(tFrom, tTo);

      expect(result, equals(tExchangeRateModel));
    });

    test('should throw ServerException when response code is not 200', () async {
      when(() => mockDio.get(any())).thenAnswer(
            (_) async => Response(
          data: 'Something went wrong',
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final call = dataSource.getExchangeRate;

      expect(() => call(tFrom, tTo), throwsA(isA<ServerException>()));
    });
  });

  group('getHistoricalRates', () {
    const tFrom = 'USD';
    const tTo = 'EUR';
    const tStartDate = '2023-01-01';
    const tEndDate = '2023-01-07';

    test('should return Map<String, double> when response 200', () async {
      final responsePayload = jsonEncode({
        "quotes": {
          "2023-01-01": {"USDEUR": 0.85},
          "2023-01-02": {"USDEUR": 0.86}
        }
      });

      when(() => mockHistoricalDio.get(any())).thenAnswer(
            (_) async => Response(
          data: jsonDecode(responsePayload),
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getHistoricalRates(tFrom, tTo, tStartDate, tEndDate);

      expect(result, isA<Map<String, double>>());
      expect(result.length, 2);
      expect(result['2023-01-01'], 0.85);
    });

    test('should throw ServerException when response code is not 200', () async {
      when(() => mockHistoricalDio.get(any())).thenAnswer(
            (_) async => Response(
          data: 'Something went wrong',
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final call = dataSource.getHistoricalRates;

      expect(() => call(tFrom, tTo, tStartDate, tEndDate), throwsA(isA<ServerException>()));
    });
  });
}
