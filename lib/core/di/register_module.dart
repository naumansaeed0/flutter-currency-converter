import 'package:dio/dio.dart';
import 'package:flutter_currency_converter/core/utils/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio();

    dio.options.baseUrl = AppConstants.baseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.queryParameters.addAll({
          'apiKey': dotenv.env['CURRENCY_API_KEY']
        });
        return handler.next(options);
      },
    ));

    return dio;
  }

  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker => InternetConnectionChecker.instance;
}