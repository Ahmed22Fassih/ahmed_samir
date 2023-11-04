class ParseException implements Exception {}

class UnauthenticatedException implements Exception {}

class MessageException implements Exception {
  final _message;

  MessageException([this._message]);

  String toString() {
    if (_message == null) return "Exception";
    return "Exception: $_message";
  }
}
