import 'dart:developer';

import 'constant.dart';
import 'entityFactory.dart';
import 'exception/errorStatus.dart';

class BaseResponse<T> {
  late int code;
  late String message;
  late T? data;

  BaseResponse(this.code, this.message, this.data);

  BaseResponse.fromJson(Map<String, dynamic> json) {
    try {
      code = json[Constant.code];
      message =
          json.containsKey(Constant.message) ? json[Constant.message] : "";
      if (json.containsKey(Constant.data)) {
        if (T.toString() == "String") {
          data = json[Constant.data].toString() as T;
        } else if (T.toString() == "Map<dynamic, dynamic>") {
          data = json[Constant.data] as T;
        } else {
          try {
            data = EntityFactory.generateOBJ(json[Constant.data]);
          } catch (e, s) {
            log("e ${e.toString()} s ${s.toString()}");
            code = ErrorStatus.PARSE_ERROR;
            data = null;
          }
        }
      }
    } catch (e, s) {
      log("e ${e.toString()} s ${s.toString()}");
      code = ErrorStatus.PARSE_ERROR;
      data = null;
    }
  }
}
