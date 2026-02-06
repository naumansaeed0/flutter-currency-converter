part of 'currency_bloc.dart';

enum CurrencyStatus { initial, loading, success, failure }

class CurrencyState extends Equatable {
  final CurrencyStatus currenciesStatus;
  final CurrencyStatus historyStatus;
  final CurrencyStatus conversionStatus;

  final List<CurrencyEntity> currencies;
  final List<HistoricalRateEntity> history;
  final ExchangeRateEntity? conversionResult;

  final String fromCurrency;
  final String toCurrency;
  final double inputAmount;
  final String? errorMessage;

  const CurrencyState({
    this.currenciesStatus = CurrencyStatus.initial,
    this.historyStatus = CurrencyStatus.initial,
    this.conversionStatus = CurrencyStatus.initial,
    this.currencies = const [],
    this.history = const [],
    this.conversionResult,
    this.fromCurrency = 'USD',
    this.toCurrency = 'EUR',
    this.inputAmount = 1.0,
    this.errorMessage,
  });

  double get convertedAmount {
    if (conversionResult == null) return 0.0;
    return conversionResult!.rate * inputAmount;
  }

  CurrencyState copyWith({
    CurrencyStatus? currenciesStatus,
    CurrencyStatus? historyStatus,
    CurrencyStatus? conversionStatus,
    List<CurrencyEntity>? currencies,
    List<HistoricalRateEntity>? history,
    ExchangeRateEntity? conversionResult,
    String? fromCurrency,
    String? toCurrency,
    double? inputAmount,
    String? errorMessage,
  }) {
    return CurrencyState(
      currenciesStatus: currenciesStatus ?? this.currenciesStatus,
      historyStatus: historyStatus ?? this.historyStatus,
      conversionStatus: conversionStatus ?? this.conversionStatus,
      currencies: currencies ?? this.currencies,
      history: history ?? this.history,
      conversionResult: conversionResult ?? this.conversionResult,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      inputAmount: inputAmount ?? this.inputAmount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    currenciesStatus,
    historyStatus,
    conversionStatus,
    currencies,
    history,
    conversionResult,
    fromCurrency,
    toCurrency,
    inputAmount,
    errorMessage,
  ];
}