import 'package:vlog_app/data/services/api/custom_exceptions.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: 25000,
      receiveTimeout: 20000,
    ),
  );

  ApiClient() {
    _init();
  }

  Future _init() async {
    dio.interceptors.add(
      (InterceptorsWrapper(
        onError: (error, handler) async {
          debugPrint("============ DIO ON ERROR ============");
          switch (error.type) {
            case DioErrorType.connectTimeout:
            case DioErrorType.sendTimeout:
            case DioErrorType.receiveTimeout:
              throw DeadlineExceededException(error.requestOptions);
            case DioErrorType.response:
              switch (error.response?.statusCode) {
                case 400:
                  BadRequestException(error.requestOptions);
                  break;
                case 401:
                  UnauthorizedException(error.requestOptions);
                  break;
                case 404:
                  NotFoundException(error.requestOptions);
                  break;
                case 409:
                  ConflictException(error.requestOptions);
                  break;
                case 500:
                  InternalServerErrorException(error.requestOptions);
                  break;
              }
              break;
            case DioErrorType.cancel:
              break;
            case DioErrorType.other:
              NoInternetConnectionException(error.requestOptions);
              break;
          }
          return handler.next(error);
        },
        onRequest: (requestOptions, handler) {
          debugPrint("============ DIO ON REQUEST ============");
          requestOptions.headers["Accept"] = "application/json";
          return handler.next(requestOptions);
        },
        onResponse: (response, handler) async {
          debugPrint("============ DIO ON RESPONSE ============");
          return handler.next(response);
        },
      )),
    );
  }
}
