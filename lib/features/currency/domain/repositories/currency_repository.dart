import 'package:dartz/dartz.dart';
import 'package:flutter_currency_converter/core/error/failures.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/exchange_rate_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/historical_rate_entity.dart'; // Import new entity

abstract class CurrencyRepository {
  Future<Either<Failure, List<CurrencyEntity>>> getCurrencies();

  Future<Either<Failure, ExchangeRateEntity>> getExchangeRate({
    required String from,
    required String to,
  });

  Future<Either<Failure, List<HistoricalRateEntity>>> getHistoricalRates({
    required String from,
    required String to,
    required DateTime startDate,
    required DateTime endDate,
  });
}