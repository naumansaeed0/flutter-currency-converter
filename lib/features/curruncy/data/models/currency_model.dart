import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:hive/hive.dart';
part 'currency_model.g.dart';

@HiveType(typeId: 0)
class CurrencyModel extends CurrencyEntity {

  @HiveField(0)
  final String code;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String countryCode;

  const CurrencyModel({
    required String code,
    required String name,
    required String countryCode,
  }) : super(
          code: code,
          name: name,
          countryCode: countryCode,
        );

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      code: json['id'] as String,
      name: json['currencyName'] as String,
      countryCode: (json['id'] as String).substring(0, 2),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': code,
    'currencyName': name,
  };
}