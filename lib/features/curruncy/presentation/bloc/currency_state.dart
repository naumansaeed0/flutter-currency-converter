part of 'currency_bloc.dart';

enum CurrencyStatus { initial, loading, success, failure }

class CurrencyState extends Equatable {
  final CurrencyStatus status;
  final List<CurrencyEntity> currencies;
  final ExchangeRateEntity? conversionResult;
  final double inputAmount;
  final Map<String, double> history;
  final String? errorMessage;

  const CurrencyState({
    this.status = CurrencyStatus.initial,
    this.currencies = const [],
    this.conversionResult,
    this.inputAmount = 1.0,
    this.history = const {},
    this.errorMessage,
  });

  double get convertedAmount {
    if (conversionResult == null) return 0.0;
    return conversionResult!.rate * inputAmount;
  }

  CurrencyState copyWith({
    CurrencyStatus? status,
    List<CurrencyEntity>? currencies,
    ExchangeRateEntity? conversionResult,
    double? inputAmount,
    Map<String, double>? history,
    String? errorMessage,
  }) {
    return CurrencyState(
      status: status ?? this.status,
      currencies: currencies ?? this.currencies,
      conversionResult: conversionResult ?? this.conversionResult,
      inputAmount: inputAmount ?? this.inputAmount,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, currencies, conversionResult, inputAmount, history, errorMessage];
}