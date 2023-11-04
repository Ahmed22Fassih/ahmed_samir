import 'package:dartz/dartz.dart';

import '../../movies/model/movies_model.dart';
import '../../movies_details/model/moviesDetailsModel.dart';

abstract class Api {
  Future<bool> checkHaveNetwork();

  Future<Either<Exception, MoviesModelResponse>> getMovies(int pageIndex);

  Future<Either<Exception, MoviesDetailsModelResponse>> getMovieByID(
      int movieID);
}
