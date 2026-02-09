import 'package:dio/dio.dart';
import 'package:flutter_currency_converter/core/network/network_info.dart';
import 'package:flutter_currency_converter/features/currency/data/datasources/currency_local_data_source.dart';
import 'package:flutter_currency_converter/features/currency/data/datasources/currency_remote_data_source.dart';
import 'package:flutter_currency_converter/features/currency/domain/repositories/currency_repository.dart';
import 'package:flutter_currency_converter/features/currency/domain/usecases/convert_currency.dart';
import 'package:flutter_currency_converter/features/currency/domain/usecases/get_currencies.dart';
import 'package:flutter_currency_converter/features/currency/domain/usecases/get_historical_rates.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}
class MockCurrencyRemoteDataSource extends Mock implements CurrencyRemoteDataSource {}
class MockCurrencyLocalDataSource extends Mock implements CurrencyLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockCurrencyRepository extends Mock implements CurrencyRepository {}
class MockGetCurrencies extends Mock implements GetCurrencies {}
class MockConvertCurrency extends Mock implements ConvertCurrency {}
class MockGetHistoricalRates extends Mock implements GetHistoricalRates {}
