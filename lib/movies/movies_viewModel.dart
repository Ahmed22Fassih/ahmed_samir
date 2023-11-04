import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../baseView/baseModel.dart';
import '../baseView/viewState.dart';
import '../data/repositories/dataManager.dart';
import 'model/movies_model.dart';

class MoviesViewModel extends BaseModel {
  MoviesViewModel({required DataManager repository})
      : super(repository: repository);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late MoviesModelResponse? moviesModel;
  int pageIndex = 1;
  int? lastPage;
  bool loadMorePage = false;

  ViewState viewStateMovies = ViewState.Loading;
  List<Movies> moviesList = [];

  Future<void> getMovies({int pageIndex = 1}) async {
    Either<Exception, MoviesModelResponse> response =
        await (repository.getMovies(pageIndex));
    setMoviesState(ViewState.Loading);
    return response.fold((error) {
      handleException(scaffoldKey.currentContext!, error);
      setMoviesState(ViewState.Error);
      notifyListeners();
    }, (movies) {
      if (movies.success != null || movies.success == false) {
        setMoviesState(ViewState.Error);
      } else {
        moviesModel = movies;
        addMoreMovies(movies.movies ?? []);
        lastPage = movies.totalPages;
        setMoviesState(ViewState.Success);
      }
      notifyListeners();
    });
  }

  bool isLastPage() {
    return pageIndex == (moviesModel?.totalPages);
  }

  // check if current page loaded is page index then increment
  Future<void> incrementPage() async {
    if (pageIndex == moviesModel?.page) {
      pageIndex++;
      await getMovies(pageIndex: pageIndex);
      loadMorePage = false;
    }
  }

  /// load next page from coupons ,that called when user arrive at end of screen.
  Future<void> loadMore() async {
    if (!isLastPage()) {
      loadMorePage = true;
      await incrementPage();
      notifyListeners();
    }
  }

  void addMoreMovies(List<Movies> movies) {
    moviesList.addAll(movies);
    log("moviesList?.length ${moviesList.length}");
    notifyListeners();
  }

  void setMoviesState(ViewState viewState) {
    viewStateMovies = viewState;
    notifyListeners();
  }

  void clearData() {
    moviesList.clear();
    pageIndex = 1;
    lastPage = 1;
    notifyListeners();
  }
}
