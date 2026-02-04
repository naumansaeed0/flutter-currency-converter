import 'package:equatable/equatable.dart';

class CurrencyEntity extends Equatable {
  final String code;
  final String name;
  final String countryCode;

  const CurrencyEntity({
    required this.code,
    required this.name,
    required this.countryCode,
  });

  @override
  List<Object> get props => [code, name, countryCode];
}