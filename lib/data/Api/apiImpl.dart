import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movies/movies/model/movies_model.dart';

import '../../movies_details/model/moviesDetailsModel.dart';
import '../networkUtils/apiPath/apiConstant.dart';
import '../networkUtils/exception/exceptionHandle.dart';
import '../networkUtils/networkUtil.dart';
import 'api.dart';

class ApiImpl implements Api {
  static String baseUrl = ApiConstant.baseURL;
  late BuildContext context;
  String deviceId = '';

  ApiImpl(this.dioUtils);

  final DioUtils dioUtils;

  @override
  Future<bool> checkHaveNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Future<Either<Exception, MoviesModelResponse>> getMovies(
      int pageIndex) async {
    try {
      Map<String, dynamic> header = {
        HttpHeaders.authorizationHeader:
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ODNmMGYxMGZkNzNmZGQ4ZWU0YWUxMWRhNDg5ODRkOSIsInN1YiI6IjY1NDE0OTg4MzNhNTMzMDBjOWVlMDg2MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6Bkm6lHCGRaccHuC7aY_NZZ6Bi-aMhXg3Ek8L37HHRE",
        'Accept': "application/json",
      };

      Map<String, dynamic> queryParameters = {"page": pageIndex};

      return dioUtils.requestDataFuture<MoviesModelResponse>(
          Method.get, ApiConstant.moviesList,
          options: Options(headers: header), queryParameters: queryParameters);
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      NetError error = ExceptionHandle.handleException(e);
      return Left(error);
    }
  }

  @override
  Future<Either<Exception, MoviesDetailsModelResponse>> getMovieByID(
      int movieID) async {
    try {
      Map<String, dynamic> header = {
        HttpHeaders.authorizationHeader:
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ODNmMGYxMGZkNzNmZGQ4ZWU0YWUxMWRhNDg5ODRkOSIsInN1YiI6IjY1NDE0OTg4MzNhNTMzMDBjOWVlMDg2MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6Bkm6lHCGRaccHuC7aY_NZZ6Bi-aMhXg3Ek8L37HHRE",
        'Accept': "application/json",
      };

      return dioUtils.requestDataFuture<MoviesDetailsModelResponse>(
          Method.get, "/$movieID",
          options: Options(headers: header));
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      NetError error = ExceptionHandle.handleException(e);
      return Left(error);
    }
  }
}
