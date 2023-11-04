import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'apiPath/apiConstant.dart';
import 'exception/errorStatus.dart';
import 'exception/exceptionHandle.dart';
import 'exception/exceptionTypes.dart';
import 'interceptors.dart';
import 'dart:developer';

import 'netResponse.dart';

//Set default Header Not configured User-Agent Eye open API 403
Map<String, dynamic> headers = {
  "Accept": "application/json",
  "User-Agent": "insomnia/6.4.1",

  "Content-Type": "application/json",
  // "Accept-Language": GlobalVars.appLanguage
  "Content-Type": "application/x-www-form-urlencoded",
};

class DioUtils {
  static final DioUtils _singleInstance = DioUtils._internal();

  static DioUtils get instance => DioUtils();

  factory DioUtils() {
    return _singleInstance;
  }

  static late Dio _dio;
  late BaseOptions _options;

  Dio getDio() {
    return _dio;
  }

  DioUtils._internal() {
    _options = BaseOptions(
      baseUrl: ApiConstant.baseURL,
      connectTimeout: const Duration(milliseconds: 6000),

      ///The interval between receiving data before and after the response stream
      receiveTimeout: const Duration(milliseconds: 12000),

      ///If the returned is json (content-type), dio is automatically converted to json by default, no need to manually transfer
      ///(https://github.com/flutterchina/dio/issues/30)
      responseType: ResponseType.plain,

      //Default headers configuration
      headers: headers,

      validateStatus: (status) {
        //Whether to use http status code for judgment, true means not to use http status code for judgment
        return true;
      },
    );
    _dio = Dio(_options);
    // (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };
    //Add cookie blocker management
//    _dio.interceptors.add(CookieManager(CookieJar()));

    //Unified request header interceptor
    _dio.interceptors.add(AuthInterceptor());

    //Web log blocker
    _dio.interceptors.add(LoggingInterceptor());

    _dio.interceptors.add(AdapterInterceptor());
  }

  ///The returned data is processed uniformly and parsed into corresponding Bean
  Future<BaseResponse<T>> _request<T>(String method, String url,
      {dynamic body,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      Options? options}) async {
    var response = await _dio.request(url,
        data: body,
        queryParameters: queryParameters,
        options: _setOptions(method, options),
        cancelToken: cancelToken);
    try {
      Map<String, dynamic> _map =
          await compute(parseData, response.data.toString());
      return BaseResponse.fromJson(_map);
    } catch (e) {
      log("PARSE_ERROR $e");
      return BaseResponse<T>(ErrorStatus.PARSE_ERROR, "PARSE_ERROR", null);
    }
  }

  Future<Either<Exception, T>> requestDataFuture<T>(
    Method method,
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    String requestMethod = _getMethod(method);

    try {
      BaseResponse<T> result = await _request<T>(requestMethod, url,
          body: body,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken);

      if (result.code == ErrorStatus.PARSE_ERROR) {
        return Left(ParseException());
      } else {
        if (result.code == 401) {
          return Left(UnauthenticatedException());
        }
        if (result.code == 404) {
          return Left(ParseException());
        }

        if (result.data == null) {
          log("error ParseException requestDataFuture  result.data==null");
          return Left(ParseException());
        }

        return Right(result.data!);
      }
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      NetError error = ExceptionHandle.handleException(e);
      return Left(error);
    }
  }

  BaseResponse parseError() {
    return BaseResponse(ErrorStatus.PARSE_ERROR, "Data parsing error", null);
  }

  Options _setOptions(String method, Options? options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

  //Request type
  String _getMethod(Method method) {
    String netMethod;
    switch (method) {
      case Method.get:
        netMethod = "GET";
        break;
      case Method.post:
        netMethod = "POST";
        break;
      case Method.put:
        netMethod = "PUT";
        break;
      case Method.delete:
        netMethod = "DELETE";
        break;
    }
    return netMethod;
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data);
}

enum Method {
  get,
  post,
  put,
  delete,
}
