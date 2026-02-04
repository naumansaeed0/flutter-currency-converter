// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;

import '../../features/curruncy/domain/usecases/convert_currency.dart' as _i676;
import '../../features/curruncy/domain/usecases/get_currencies.dart' as _i83;
import '../../features/curruncy/domain/usecases/get_historical_rates.dart'
    as _i452;
import '../network/network_info.dart' as _i932;
import '../network/network_info_impl.dart' as _i865;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i973.InternetConnectionChecker>(
        () => registerModule.internetConnectionChecker);
    gh.lazySingleton<_i676.ConvertCurrency>(
        () => _i676.ConvertCurrency(gh<InvalidType>()));
    gh.lazySingleton<_i83.GetCurrencies>(
        () => _i83.GetCurrencies(gh<InvalidType>()));
    gh.lazySingleton<_i452.GetHistoricalRates>(
        () => _i452.GetHistoricalRates(gh<InvalidType>()));
    gh.lazySingleton<_i932.NetworkInfo>(
        () => _i865.NetworkInfoImpl(gh<_i973.InternetConnectionChecker>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
