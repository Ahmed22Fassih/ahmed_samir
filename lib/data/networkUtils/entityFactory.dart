import '../../movies/model/movies_model.dart';
import '../../movies_details/model/moviesDetailsModel.dart';

class EntityFactory {
  static T? generateOBJ<T>(json) {
    if (T.toString() == "MoviesModelResponse") {
      return MoviesModelResponse.fromJson(json) as T;
    } else if (T.toString() == "MoviesDetailsModelResponse") {
      return MoviesDetailsModelResponse.fromJson(json) as T;
    } else {
      return null;
    }
  }
}
