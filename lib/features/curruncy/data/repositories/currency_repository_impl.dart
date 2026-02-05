import 'package:dartz/dartz.dart';
import 'package:flutter_currency_converter/core/error/exceptions.dart';
import 'package:flutter_currency_converter/core/error/failures.dart';
import 'package:flutter_currency_converter/core/network/network_info.dart';
import 'package:flutter_currency_converter/features/currency/data/datasources/currency_local_data_source.dart';
import 'package:flutter_currency_converter/features/currency/data/datasources/currency_remote_data_source.dart';
import 'package:flutter_currency_converter/features/currency/data/models/history_model.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/exchange_rate_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/repositories/currency_repository.dart';
import 'package:injectable/injectable.dart';

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
  Future<Either<Failure, Map<String, double>>> getHistoricalRates({
    required String from,
    required String to,
    required String startDate,
    required String endDate,
  }) async {

    try {

      final localHistory = await localDataSource.getLastHistory(from, to);

      if (localHistory.rates.containsKey(endDate)) {
        return Right(localHistory.rates);
      }

    } on CacheException {
    // We catch the error and do nothing, so the code falls through
    }
    if (await networkInfo.isConnected) {
      try {

        final historyMap = await remoteDataSource.getHistoricalRates(from, to, startDate, endDate);
        final historyModel = HistoryModel(
          from: from,
          to: to,
          rates: historyMap,
          lastUpdated: DateTime.now().toIso8601String(),
        );
        await localDataSource.cacheHistory(historyModel);

        return Right(historyMap);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {

      try {

        final localHistory = await localDataSource.getLastHistory(from, to);
        return Right(localHistory.rates);
      } on CacheException {
         return const Left(NetworkFailure());
      }
    }
  }
}