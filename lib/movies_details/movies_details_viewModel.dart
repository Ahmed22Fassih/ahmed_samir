import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../baseView/baseModel.dart';
import '../baseView/viewState.dart';
import '../data/repositories/dataManager.dart';
import 'model/moviesDetailsModel.dart';

class MoviesDetailsViewModel extends BaseModel {
  MoviesDetailsViewModel({required DataManager repository})
      : super(repository: repository);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ViewState viewStateMovies = ViewState.Loading;

  late MoviesDetailsModelResponse moviesDetailsModelResponse;

  Future<void> getMoviesByID(int movieID) async {
    Either<Exception, MoviesDetailsModelResponse> response =
        await (repository.getMovieByID(movieID));
    setMoviesState(ViewState.Loading);
    return response.fold((error) {
      handleException(scaffoldKey.currentContext!, error);
      setMoviesState(ViewState.Error);
      notifyListeners();
    }, (movies) {
      if (movies.success != null || movies.success == false) {
        setMoviesState(ViewState.Error);
      } else {
        moviesDetailsModelResponse = movies;
        setMoviesState(ViewState.Success);
      }
      notifyListeners();
    });
  }

  void setMoviesState(ViewState viewState) {
    viewStateMovies = viewState;
    notifyListeners();
  }
}
