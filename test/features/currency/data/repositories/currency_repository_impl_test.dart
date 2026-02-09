import 'package:dartz/dartz.dart';
import 'package:flutter_currency_converter/core/error/exceptions.dart';
import 'package:flutter_currency_converter/core/error/failures.dart';
import 'package:flutter_currency_converter/features/currency/data/models/currency_model.dart';
import 'package:flutter_currency_converter/features/currency/data/models/exchange_rate_model.dart';
import 'package:flutter_currency_converter/features/currency/data/models/history_model.dart';
import 'package:flutter_currency_converter/features/currency/data/repositories/currency_repository_impl.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/exchange_rate_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_helper.dart';

void main() {
  late CurrencyRepositoryImpl repository;
  late MockCurrencyRemoteDataSource mockRemoteDataSource;
  late MockCurrencyLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockCurrencyRemoteDataSource();
    mockLocalDataSource = MockCurrencyLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CurrencyRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
    registerFallbackValue(HistoryModel(from: 'USD', to: 'EUR', rates: {}, lastUpdated: ''));
    registerFallbackValue(<CurrencyModel>[]);
  });

  group('getCurrencies', () {
    final List<CurrencyModel> tCurrencyModelList = [
      const CurrencyModel(code: 'USD', name: 'United States Dollar', countryCode: 'us'),
      const CurrencyModel(code: 'EUR', name: 'Euro', countryCode: 'eu'),
    ];
    final List<CurrencyEntity> tCurrencyEntityList = tCurrencyModelList;

    test('should return local data when cache is available', () async {
      when(() => mockLocalDataSource.getLastCurrencies()).thenAnswer((_) async => tCurrencyModelList);

      final result = await repository.getCurrencies();

      verify(() => mockLocalDataSource.getLastCurrencies());
      verifyZeroInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockNetworkInfo);
      expect(result, equals(Right(tCurrencyEntityList)));
    });

    test('should fetch from remote when cache is empty and device is online', () async {
      when(() => mockLocalDataSource.getLastCurrencies()).thenThrow(CacheException());
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCurrencies()).thenAnswer((_) async => tCurrencyModelList);
      when(() => mockLocalDataSource.cacheCurrencies(any())).thenAnswer((_) async => {});

      final result = await repository.getCurrencies();

      verify(() => mockLocalDataSource.getLastCurrencies());
      verify(() => mockNetworkInfo.isConnected);
      verify(() => mockRemoteDataSource.getCurrencies());
      verify(() => mockLocalDataSource.cacheCurrencies(tCurrencyModelList));
      expect(result, equals(Right(tCurrencyEntityList)));
    });

    test('should return server failure when remote fetch fails', () async {
      when(() => mockLocalDataSource.getLastCurrencies()).thenThrow(CacheException());
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCurrencies()).thenThrow(ServerException());

      final result = await repository.getCurrencies();

      verify(() => mockLocalDataSource.getLastCurrencies());
      verify(() => mockNetworkInfo.isConnected);
      verify(() => mockRemoteDataSource.getCurrencies());
      expect(result, equals(const Left(ServerFailure('Server Error'))));
    });

    test('should return network failure when cache is empty and device is offline', () async {
      when(() => mockLocalDataSource.getLastCurrencies()).thenThrow(CacheException());
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getCurrencies();

      verify(() => mockLocalDataSource.getLastCurrencies());
      verify(() => mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockRemoteDataSource);
      expect(result, equals(const Left(NetworkFailure())));
    });
  });

  group('getExchangeRate', () {
    const tFrom = 'USD';
    const tTo = 'EUR';
    final tExchangeRateModel = ExchangeRateModel(fromCurrency: tFrom, toCurrency: tTo, rate: 0.85);
    final ExchangeRateEntity tExchangeRateEntity = tExchangeRateModel;

    test('should check network connectivity first', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getExchangeRate(any(), any())).thenAnswer((_) async => tExchangeRateModel);

      final result = await repository.getExchangeRate(from: tFrom, to: tTo);

      verify(() => mockNetworkInfo.isConnected);
      verify(() => mockRemoteDataSource.getExchangeRate(tFrom, tTo));
      expect(result, equals(Right(tExchangeRateEntity)));
    });

    test('should return server failure when remote call fails', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getExchangeRate(any(), any())).thenThrow(ServerException());

      final result = await repository.getExchangeRate(from: tFrom, to: tTo);

      verify(() => mockNetworkInfo.isConnected);
      verify(() => mockRemoteDataSource.getExchangeRate(tFrom, tTo));
      expect(result, equals(const Left(ServerFailure('Server Error'))));
    });

    test('should return network failure immediately when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getExchangeRate(from: tFrom, to: tTo);

      verify(() => mockNetworkInfo.isConnected);
      verifyZeroInteractions(mockRemoteDataSource);
      expect(result, equals(const Left(NetworkFailure())));
    });
  });

  group('getHistoricalRates', () {
    const tFrom = 'USD';
    const tTo = 'EUR';
    final tStartDate = DateTime(2023, 1, 1);
    final tEndDate = DateTime(2023, 1, 2);
    final tRates = {
      '2023-01-01': 0.85,
      '2023-01-02': 0.86,
    };
    final tHistoryModel = HistoryModel(from: tFrom, to: tTo, rates: tRates, lastUpdated: DateTime.now().toIso8601String());

    test('should return cached data when it covers the requested date range', () async {
      when(() => mockLocalDataSource.getLastHistory(any(), any())).thenAnswer((_) async => tHistoryModel);

      final result = await repository.getHistoricalRates(from: tFrom, to: tTo, startDate: tStartDate, endDate: tEndDate);

      verify(() => mockLocalDataSource.getLastHistory(tFrom, tTo));
      verifyZeroInteractions(mockNetworkInfo);
      verifyZeroInteractions(mockRemoteDataSource);
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return right'),
        (rates) {
          expect(rates.length, 2);
          expect(rates[0].rate, 0.85);
          expect(rates[1].rate, 0.86);
        },
      );
    });

    test('should fetch from remote when cache is empty and device is online', () async {
      when(() => mockLocalDataSource.getLastHistory(any(), any())).thenThrow(CacheException());
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getHistoricalRates(any(), any(), any(), any())).thenAnswer((_) async => tRates);
      when(() => mockLocalDataSource.cacheHistory(any())).thenAnswer((_) async => {});

      final result = await repository.getHistoricalRates(from: tFrom, to: tTo, startDate: tStartDate, endDate: tEndDate);

      verify(() => mockLocalDataSource.getLastHistory(tFrom, tTo));
      verify(() => mockNetworkInfo.isConnected);
      verify(() => mockRemoteDataSource.getHistoricalRates(tFrom, tTo, '2023-01-01', '2023-01-02'));
      verify(() => mockLocalDataSource.cacheHistory(any()));
      expect(result.isRight(), true);
    });

    test('should return server failure when remote fetch fails', () async {
      when(() => mockLocalDataSource.getLastHistory(any(), any())).thenThrow(CacheException());
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getHistoricalRates(any(), any(), any(), any())).thenThrow(ServerException());

      final result = await repository.getHistoricalRates(from: tFrom, to: tTo, startDate: tStartDate, endDate: tEndDate);

      verify(() => mockLocalDataSource.getLastHistory(tFrom, tTo));
      verify(() => mockNetworkInfo.isConnected);
      verify(() => mockRemoteDataSource.getHistoricalRates(tFrom, tTo, '2023-01-01', '2023-01-02'));
      expect(result, equals(const Left(ServerFailure('Server Error'))));
    });

    test('should return network failure when offline and no cache available', () async {
      when(() => mockLocalDataSource.getLastHistory(any(), any())).thenThrow(CacheException());
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getHistoricalRates(from: tFrom, to: tTo, startDate: tStartDate, endDate: tEndDate);

      verify(() => mockNetworkInfo.isConnected);
      expect(result, equals(const Left(NetworkFailure())));
    });
  });
}
