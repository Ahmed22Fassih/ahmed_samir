import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/baseView/viewState.dart';
import 'package:movies/main.dart';
import 'package:provider/provider.dart';

import '../baseView/baseView.dart';
import '../data/sharedPreference/helper.dart';
import '../movies_details/movies_details_screen.dart';
import '../utils/images/remote_image.dart';
import '../utils/navigator.dart';
import 'model/movies_model.dart';
import 'movies_viewModel.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late MoviesViewModel _moviesViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<MoviesViewModel>(
        model: di<MoviesViewModel>(),
        onModelReady: (model) {
          _moviesViewModel = model;
          _moviesViewModel.getMovies();
        },
        builder: (context, child) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 812.h,
                  child: Center(
                    child: Selector<MoviesViewModel, ViewState>(
                      selector: (context, viewModel) =>
                          viewModel.viewStateMovies,
                      builder: (_, movies, __) {
                        if (movies == ViewState.Loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (scrollInfo is ScrollEndNotification) {
                                _moviesViewModel.loadMore();
                              }
                              return false;
                            },
                            child: Consumer<MoviesViewModel>(
                              builder: (_, movies, __) {
                                return GridView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  itemCount: _moviesViewModel.moviesList.length,
                                  itemBuilder: (ctx, i) {
                                    return InkWell(
                                        onTap: () {
                                          navigateAndKeepStack(
                                              context,
                                              MoviesDetailsScreen(
                                                movieID: _moviesViewModel
                                                        .moviesList[i].id ??
                                                    0,
                                              ));
                                        },
                                        child: movieItem(i));
                                  },
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.0,
                                    crossAxisSpacing: 0.0,
                                    mainAxisSpacing: 5,
                                    mainAxisExtent: 160,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ));
        });
  }

  Card movieItem(int i) {
    return Card(
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              "${Const.imageHost}${_moviesViewModel.moviesList[i].backdropPath ?? ""}",
              fit: BoxFit.fill,
            ),
            Spacer(),
            Text(
              "${_moviesViewModel.moviesList[i].title ?? ""}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
