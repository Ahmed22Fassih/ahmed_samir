class Constant {
  static const bool inProduction =
  const bool.fromEnvironment("dart.vm.product");

  static const String data = "data";
  static const String message = "message";
  static const String code = "code";
}
