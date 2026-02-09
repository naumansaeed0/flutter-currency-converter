import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_currency_converter/core/error/failures.dart';
import 'package:flutter_currency_converter/core/usecases/usecase.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/exchange_rate_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/historical_rate_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/usecases/convert_currency.dart';
import 'package:flutter_currency_converter/features/currency/domain/usecases/get_historical_rates.dart';
import 'package:flutter_currency_converter/features/currency/presentation/bloc/currency_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_helper.dart';

void main() {
  late CurrencyBloc bloc;
  late MockGetCurrencies mockGetCurrencies;
  late MockConvertCurrency mockConvertCurrency;
  late MockGetHistoricalRates mockGetHistoricalRates;

  setUp(() {
    mockGetCurrencies = MockGetCurrencies();
    mockConvertCurrency = MockConvertCurrency();
    mockGetHistoricalRates = MockGetHistoricalRates();
    bloc = CurrencyBloc(
      mockGetCurrencies,
      mockConvertCurrency,
      mockGetHistoricalRates,
    );
    
    registerFallbackValue(NoParams());
    registerFallbackValue(const ConvertCurrencyParams(from: 'USD', to: 'EUR'));
    registerFallbackValue(GetHistoryParams(from: 'USD', to: 'EUR', startDate: DateTime.now(), endDate: DateTime.now()));
  });

  group('CurrencyBloc', () {
    test('initial state should be CurrencyState()', () {
      expect(bloc.state, const CurrencyState());
    });

    group('GetInitialDataEvent', () {
      final List<CurrencyEntity> tCurrencyList = [
        const CurrencyEntity(code: 'USD', name: 'US Dollar', countryCode: 'us'),
        const CurrencyEntity(code: 'EUR', name: 'Euro', countryCode: 'eu'),
      ];
      final List<HistoricalRateEntity> tHistoryList = [
        HistoricalRateEntity(date: DateTime(2023, 1, 1), rate: 0.85),
      ];

      blocTest<CurrencyBloc, CurrencyState>(
        'emits [loading, success] when getCurrencies and getHistoricalRates return data',
        build: () {
          when(() => mockGetCurrencies(any())).thenAnswer((_) async => Right(tCurrencyList));
          when(() => mockGetHistoricalRates(any())).thenAnswer((_) async => Right(tHistoryList));
          return bloc;
        },
        act: (bloc) => bloc.add(GetInitialDataEvent()),
        expect: () => [
          const CurrencyState(currenciesStatus: CurrencyStatus.loading, historyStatus: CurrencyStatus.loading),
          CurrencyState(currenciesStatus: CurrencyStatus.success, historyStatus: CurrencyStatus.loading, currencies: tCurrencyList),
          CurrencyState(currenciesStatus: CurrencyStatus.success, historyStatus: CurrencyStatus.success, currencies: tCurrencyList, history: tHistoryList),
        ],
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'emits [loading, failure] when getCurrencies fails',
        build: () {
          when(() => mockGetCurrencies(any())).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
          return bloc;
        },
        act: (bloc) => bloc.add(GetInitialDataEvent()),
        expect: () => [
          const CurrencyState(currenciesStatus: CurrencyStatus.loading, historyStatus: CurrencyStatus.loading),
          const CurrencyState(currenciesStatus: CurrencyStatus.failure, historyStatus: CurrencyStatus.loading, errorMessage: 'Server Error'),
        ],
      );
    });

    group('ConvertCurrencyEvent', () {
      const tFrom = 'USD';
      const tTo = 'EUR';
      const tAmount = 100.0;
      const tExchangeRate = ExchangeRateEntity(fromCurrency: tFrom, toCurrency: tTo, rate: 0.85);

      blocTest<CurrencyBloc, CurrencyState>(
        'emits [loading, success] when convertCurrency returns data',
        build: () {
          when(() => mockConvertCurrency(any())).thenAnswer((_) async => const Right(tExchangeRate));
          return bloc;
        },
        seed: () => const CurrencyState(fromCurrency: tFrom, toCurrency: tTo),
        act: (bloc) => bloc.add(const ConvertCurrencyEvent(amount: tAmount)),
        expect: () => [
          const CurrencyState(fromCurrency: tFrom, toCurrency: tTo, conversionStatus: CurrencyStatus.loading, inputAmount: tAmount),
          const CurrencyState(fromCurrency: tFrom, toCurrency: tTo, conversionStatus: CurrencyStatus.success, inputAmount: tAmount, conversionResult: tExchangeRate),
        ],
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'emits [loading, failure] when convertCurrency fails',
        build: () {
          when(() => mockConvertCurrency(any())).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
          return bloc;
        },
        seed: () => const CurrencyState(fromCurrency: tFrom, toCurrency: tTo),
        act: (bloc) => bloc.add(const ConvertCurrencyEvent(amount: tAmount)),
        expect: () => [
          const CurrencyState(fromCurrency: tFrom, toCurrency: tTo, conversionStatus: CurrencyStatus.loading, inputAmount: tAmount),
          const CurrencyState(fromCurrency: tFrom, toCurrency: tTo, conversionStatus: CurrencyStatus.failure, inputAmount: tAmount, errorMessage: 'Server Error'),
        ],
      );
    });

    group('Currency Selection Events', () {
      blocTest<CurrencyBloc, CurrencyState>(
        'emits updated state and triggers conversion on SourceCurrencyChanged',
        build: () {
          when(() => mockConvertCurrency(any())).thenAnswer((_) async => const Right(ExchangeRateEntity(fromCurrency: 'GBP', toCurrency: 'EUR', rate: 1.1)));
          return bloc;
        },
        act: (bloc) => bloc.add(const SourceCurrencyChanged('GBP')),
        expect: () => [
          const CurrencyState(fromCurrency: 'GBP', conversionStatus: CurrencyStatus.loading),
          const CurrencyState(fromCurrency: 'GBP', conversionStatus: CurrencyStatus.success, inputAmount: 1.0, conversionResult: ExchangeRateEntity(fromCurrency: 'GBP', toCurrency: 'EUR', rate: 1.1)),
        ],
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'emits updated state and triggers conversion on TargetCurrencyChanged',
        build: () {
          when(() => mockConvertCurrency(any())).thenAnswer((_) async => const Right(ExchangeRateEntity(fromCurrency: 'USD', toCurrency: 'GBP', rate: 0.75)));
          return bloc;
        },
        act: (bloc) => bloc.add(const TargetCurrencyChanged('GBP')),
        expect: () => [
          const CurrencyState(toCurrency: 'GBP', conversionStatus: CurrencyStatus.loading),
          const CurrencyState(toCurrency: 'GBP', conversionStatus: CurrencyStatus.success, inputAmount: 1.0, conversionResult: ExchangeRateEntity(fromCurrency: 'USD', toCurrency: 'GBP', rate: 0.75)),
        ],
      );
      
       blocTest<CurrencyBloc, CurrencyState>(
        'emits swapped currencies and triggers conversion on SwapCurrenciesEvent',
        build: () {
          when(() => mockConvertCurrency(any())).thenAnswer((_) async => const Right(ExchangeRateEntity(fromCurrency: 'EUR', toCurrency: 'USD', rate: 1.18)));
          return bloc;
        },
        seed: () => const CurrencyState(fromCurrency: 'USD', toCurrency: 'EUR'),
        act: (bloc) => bloc.add(SwapCurrenciesEvent()),
        expect: () => [
          const CurrencyState(fromCurrency: 'EUR', toCurrency: 'USD'),
          const CurrencyState(fromCurrency: 'EUR', toCurrency: 'USD', conversionStatus: CurrencyStatus.loading, inputAmount: 1.0),
          const CurrencyState(fromCurrency: 'EUR', toCurrency: 'USD', conversionStatus: CurrencyStatus.success, inputAmount: 1.0, conversionResult: ExchangeRateEntity(fromCurrency: 'EUR', toCurrency: 'USD', rate: 1.18)),
        ],
      );
    });
  });
}
