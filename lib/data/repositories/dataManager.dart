import '../Api/api.dart';

abstract class DataManager implements Api {
  void saveToken(String token);

  Future<bool> removeToken();
}
