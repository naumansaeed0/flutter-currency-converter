import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_currency_converter/core/error/exceptions.dart';
import 'package:flutter_currency_converter/core/error/failures.dart';
import 'package:flutter_currency_converter/core/network/network_info.dart';
import 'package:flutter_currency_converter/features/currency/data/datasources/currency_local_data_source.dart';
import 'package:flutter_currency_converter/features/currency/data/datasources/currency_remote_data_source.dart';
import 'package:flutter_currency_converter/features/currency/data/models/history_model.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/exchange_rate_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/historical_rate_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/repositories/currency_repository.dart';

@LazySingleton(as: CurrencyRepository)
class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CurrencyEntity>>> getCurrencies() async {
    try {
      final localCurrencies = await localDataSource.getLastCurrencies();
      return Right(localCurrencies);
    } on CacheException {
      if (await networkInfo.isConnected) {
        try {
          final remoteCurrencies = await remoteDataSource.getCurrencies();
          await localDataSource.cacheCurrencies(remoteCurrencies);
          return Right(remoteCurrencies);
        } on ServerException {
          return const Left(ServerFailure('Server Error'));
        }
      } else {
        return const Left(NetworkFailure());
      }
    }
  }

  @override
  Future<Either<Failure, ExchangeRateEntity>> getExchangeRate({required String from, required String to}) async {
    if (await networkInfo.isConnected) {
      try {
        final rate = await remoteDataSource.getExchangeRate(from, to);
        return Right(rate);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<HistoricalRateEntity>>> getHistoricalRates({
    required String from,
    required String to,
    required DateTime startDate,
    required DateTime endDate,
  }) async {


    final dateFormat = DateFormat('yyyy-MM-dd');
    final startStr = dateFormat.format(startDate);
    final endStr = dateFormat.format(endDate);


    List<HistoricalRateEntity> mapToEntities(Map<String, double> rates) {
      return rates.entries.map((e) {
        return HistoricalRateEntity(
          date: DateTime.parse(e.key),
          rate: e.value,
        );
      }).toList();
    }

    try {
      final localHistory = await localDataSource.getLastHistory(from, to);

      if (localHistory.rates.containsKey(endStr)) {
        return Right(mapToEntities(localHistory.rates));
      }
    } on CacheException {
      // Empty cache, fall through
    }

    if (await networkInfo.isConnected) {
      try {
        final historyMap = await remoteDataSource.getHistoricalRates(from, to, startStr, endStr);

        final historyModel = HistoryModel(
          from: from,
          to: to,
          rates: historyMap,
          lastUpdated: DateTime.now().toIso8601String(),
        );

        await localDataSource.cacheHistory(historyModel);

        return Right(mapToEntities(historyMap));
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {

      try {
        final localHistory = await localDataSource.getLastHistory(from, to);
        return Right(mapToEntities(localHistory.rates));
      } on CacheException {
        return const Left(NetworkFailure());
      }
    }
  }
}