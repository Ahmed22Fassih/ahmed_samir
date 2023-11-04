import 'package:dartz/dartz.dart';

import '../../movies/model/movies_model.dart';
import '../../movies_details/model/moviesDetailsModel.dart';
import '../Api/apiImpl.dart';
import '../sharedPreference/prefs.dart';
import 'dataManager.dart';

class DataManagerImpl implements DataManager {
  ApiImpl api;
  Prefs prefs;

  DataManagerImpl(this.api, this.prefs);

  @override
  void saveToken(String token) {
    if (token.isEmpty) return;
    prefs.saveToken("Bearer $token");
  }

  @override
  Future<bool> checkHaveNetwork() {
    return api.checkHaveNetwork();
  }

  @override
  Future<bool> removeToken() {
    return prefs.removeToken();
  }

  @override
  Future<Either<Exception, MoviesModelResponse>> getMovies(int pageIndex) {
    return api.getMovies(pageIndex);
  }

  @override
  Future<Either<Exception, MoviesDetailsModelResponse>> getMovieByID(
      int movieId) {
    return api.getMovieByID(movieId);
  }
}
