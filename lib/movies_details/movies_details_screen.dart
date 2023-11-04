import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/baseView/viewState.dart';
import 'package:provider/provider.dart';

import '../baseView/baseView.dart';
import '../data/sharedPreference/helper.dart';
import '../main.dart';
import 'movies_details_viewModel.dart';

class MoviesDetailsScreen extends StatefulWidget {
  final int movieID;
  const MoviesDetailsScreen({Key? key, required this.movieID})
      : super(key: key);

  @override
  _MoviesDetailsScreenState createState() => _MoviesDetailsScreenState();
}

class _MoviesDetailsScreenState extends State<MoviesDetailsScreen> {
  late MoviesDetailsViewModel _detailsViewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView<MoviesDetailsViewModel>(
      model: di<MoviesDetailsViewModel>(),
      onModelReady: (model) {
        _detailsViewModel = model;
        _detailsViewModel.getMoviesByID(widget.movieID);
      },
      builder: (context, child) {
        return Scaffold(
          body: Selector<MoviesDetailsViewModel, ViewState>(
            selector: (context, viewModel) => viewModel.viewStateMovies,
            builder: (_, view, __) {
              if (view == ViewState.Loading) {
                return Center(
                  child: SizedBox(
                      height: 24.h,
                      width: 24.h,
                      child: const CircularProgressIndicator()),
                );
              } else {
                return Column(
                  children: [
                    Image.network(
                      "${Const.imageHost}${_detailsViewModel.moviesDetailsModelResponse.backdropPath ?? ""}",
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            _detailsViewModel
                                    .moviesDetailsModelResponse.title ??
                                "",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            _detailsViewModel
                                    .moviesDetailsModelResponse.overview ??
                                "",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
