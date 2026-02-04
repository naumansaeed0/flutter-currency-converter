import 'package:dartz/dartz.dart';
import 'package:flutter_currency_converter/core/error/failures.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/exchange_rate_entity.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, List<CurrencyEntity>>> getCurrencies();

  Future<Either<Failure, ExchangeRateEntity>> getExchangeRate({
    required String from,
    required String to,
  });


  Future<Either<Failure, Map<String, double>>> getHistoricalRates({
    required String from,
    required String to,
    required String startDate, // YYYY-MM-DD
    required String endDate,   // YYYY-MM-DD
  });
}