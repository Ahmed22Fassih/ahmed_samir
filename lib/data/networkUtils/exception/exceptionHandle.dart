import 'dart:io';

import 'package:dio/dio.dart';

import 'errorStatus.dart';

class ExceptionHandle {
  static String globalError = "Some Thing Wrong Happened...";

  static NetError handleException(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.badResponse) {
        dynamic e = error.error;

        if (e is SocketException) {
          return NetError(ErrorStatus.SOCKET_ERROR, globalError);
        }

        if (e is HttpException) {
          return NetError(ErrorStatus.SERVER_ERROR, globalError);
        }

        return NetError(ErrorStatus.NETWORK_ERROR, globalError);
      } else {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          return NetError(ErrorStatus.TIMEOUT_ERROR, globalError);
        } else if (error.type == DioExceptionType.cancel) {
          return NetError(ErrorStatus.CANCEL_ERROR, "");
        } else {
          return NetError(ErrorStatus.UNKNOWN_ERROR, globalError);
        }
      }
    } else {
      return NetError(ErrorStatus.UNKNOWN_ERROR, globalError);
    }
  }
}

class NetError implements Exception {
  int code;
  String msg;

  NetError(this.code, this.msg);
}
