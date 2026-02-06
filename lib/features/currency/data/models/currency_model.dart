import 'package:hive/hive.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';

part 'currency_model.g.dart';

@HiveType(typeId: 0)
class CurrencyModel extends CurrencyEntity {
  @override
  @HiveField(0)
  final String code;

  @override
  @HiveField(1)
  final String name;

  @override
  @HiveField(2)
  final String countryCode;

  const CurrencyModel({
    required this.code,
    required this.name,
    required this.countryCode,
  }) : super(
    code: code,
    name: name,
    countryCode: countryCode,
  );

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    final currencyCode = json['id'] as String;

    return CurrencyModel(
      code: currencyCode,
      name: json['currencyName'] as String,
      countryCode: _mapCurrencyToCountry(currencyCode),
    );
  }

  static String _mapCurrencyToCountry(String currencyCode) {
    if (_currencyToCountryMap.containsKey(currencyCode)) {
      return _currencyToCountryMap[currencyCode]!;
    }

    // This handles the long tail of other currencies
    if (currencyCode.length >= 2) {
      return currencyCode.substring(0, 2).toLowerCase();
    }

    return 'unknown';
  }

  static const Map<String, String> _currencyToCountryMap = {
    'USD': 'us', // United States
    'EUR': 'eu', // European Union
    'GBP': 'gb', // United Kingdom
    'JPY': 'jp', // Japan
    'CNY': 'cn', // China
    'INR': 'in', // India
    'AUD': 'au', // Australia
    'CAD': 'ca', // Canada
    'CHF': 'ch', // Switzerland
    'HKD': 'hk', // Hong Kong
    'SGD': 'sg', // Singapore
    'SEK': 'se', // Sweden
    'KRW': 'kr', // South Korea
    'BRL': 'br', // Brazil
    'RUB': 'ru', // Russia
    'ZAR': 'za', // South Africa
    'MXN': 'mx', // Mexico
    'PKR': 'pk', // Pakistan
    'SAR': 'sa', // Saudi Arabia
    'AED': 'ae', // UAE
    'TRY': 'tr', // Turkey
    'NZD': 'nz', // New Zealand
  };
}