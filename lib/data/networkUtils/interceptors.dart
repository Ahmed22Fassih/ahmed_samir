import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sprintf/sprintf.dart';

import 'exception/errorStatus.dart';

///Header management interceptor
class AuthInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // options.headers["Accept-Language"] = GlobalVars.appLanguage;
    return super.onRequest(options, handler);
  }
}

///Log interceptor settings
class LoggingInterceptor extends Interceptor {
  late DateTime startTime;
  late DateTime endTime;

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    startTime = DateTime.now();
    log("--------------Request Start---------------");

    ///print full path request
    if (options.queryParameters.isEmpty) {
      if (options.path.contains(options.baseUrl)) {
        log("RequestUrl:" + options.path);
      } else {
        log("RequestUrl:" + options.baseUrl + options.path);
      }
    } else {
      ///If queryParameters is not empty, splice into a complete URl
      log("RequestUrl:" +
          options.baseUrl +
          options.path +
          "?" +
          Transformer.urlEncodeMap(options.queryParameters));
    }

    log("RequestMethod:" +
        options.method +
        "\n" +
        "RequestHeaders:" +
        options.headers.toString() +
        "\n" +
        "RequestContentType:" +
        options.contentType.toString() +
        "\n" +
        "RequestData:${options.data.toString()}" +
        "\n");
    log("RequestContentType:" + options.contentType.toString());
    log("RequestData:${options.data.toString()}");

    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) {
    endTime = DateTime.now();
    //Request duration
    int duration = endTime.difference(startTime).inMilliseconds;
    log("----------End Request $duration millisecond---------");
//    log(response.data);
    return super.onResponse(response, handler);
  }

  @override
  onError(DioException err, ErrorInterceptorHandler handler) {
    log("--------------Error-----------");
    log(err.error.toString());
    log(err.toString());

    return super.onError(err, handler);
  }
}

//parsing data
class AdapterInterceptor extends Interceptor {
  static const String MSG = "msg";
  static const String SLASH = "\"";
  static const String MESSAGE = "message";
  static const String ERROR = "validateError";

  static const String DEFAULT = "\"NOT_FOUND\"";
  static const String NOT_FOUND = "Some Thing Wrong Happened";

  static const String FAILURE_FORMAT = "{\"code\":%d,\"data\": %s }";
  static const String SUCCESS_FORMAT =
      "{\"code\":0,\"data\":%s,\"message\":\"\"}";

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) {
    Response rp = adapterData(response);
    return super.onResponse(rp, handler);
  }

  @override
  onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      adapterData(err.response!);
    }
    return super.onError(err, handler);
  }

  Response adapterData(Response response) {
    String result;
    String content = response.data == null ? "" : response.data.toString();
    if (response.statusCode == ErrorStatus.SUCCESS) {
      if (content.isEmpty) {
        content = DEFAULT;
      }
      result = sprintf(SUCCESS_FORMAT, [content]);
      response.statusCode = ErrorStatus.SUCCESS;
    } else {
      result = sprintf(FAILURE_FORMAT, [response.statusCode, content]);
      response.statusCode = ErrorStatus.SUCCESS;
    }
    if (response.statusCode == ErrorStatus.SUCCESS) {
      log("ResponseCode:${response.statusCode}");
      log("response:${response.data}");
    } else {
      log("ResponseCode:${response.statusCode}");
      log("response:${response.data}");
    }
    log(result);
    response.data = result;
    return response;
  }
}
