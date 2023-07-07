import 'dart:io';

import 'package:dio/dio.dart';
import 'package:koobits_flutter_app/core/common/error/exception.dart';
import 'package:koobits_flutter_app/core/common/utils/logger/i_logger.dart';
import 'package:koobits_flutter_app/core/di/service_locator.dart';

mixin ApiClientExceptionHandler {
  Exception apiExceptionHandler(Exception exception, {Error? error}) {
    if (exception is SocketException) {
      return ServerException(exception);
    } else if (exception is DioException) {
      return checkDioErrorException(exception);
    } else {
      sl.get<ILogger>().e(error);
      if (error != null) {
        if (error is TypeError) {
          return ParsingException();
        }
      }
      return UnknownException();
    }
  }

  Exception checkDioErrorException(DioException exception) {
    var logger = sl.get<ILogger>();
    if (exception.error is SocketException) {
      return const SocketException('');
    } else if (exception.response != null) {
      if (exception.response!.statusCode == 500) {
        logger.e(
            'Error --> ${exception.requestOptions.uri.toString()}\nMessage: ${exception.response!.statusMessage}\n${exception.response!}');
        return ServerException(exception);
      }
    }
    logger.e('Error --> ${exception.toString()}');
    return UnknownException();
  }
}