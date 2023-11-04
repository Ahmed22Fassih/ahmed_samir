import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movies/baseView/viewState.dart';

import '../data/networkUtils/exception/exceptionHandle.dart';
import '../data/networkUtils/exception/exceptionTypes.dart';
import '../data/repositories/dataManager.dart';
import '../loading/LoadingDialog.dart';

class BaseModel extends ChangeNotifier {
  DataManager repository;
  bool disposed = false;

  BaseModel({required DataManager repository}) : repository = repository;

  ViewState _state = ViewState.Loading;

  ViewState get state => _state;

  LoadingDialog? loadingDialog;

  void hideDialog(BuildContext context) {
    if (loadingDialog != null && loadingDialog!.isShowing()!) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      loadingDialog = null;
    }
  }

  void showLoadingDialog(BuildContext context) async {
    loadingDialog ??= LoadingDialog();
    showDialog(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (BuildContext context) => loadingDialog!);
  }

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    disposed = true;
  }

  @override
  void notifyListeners() {
    if (!disposed) {
      super.notifyListeners();
    }
  }

  String handleException(BuildContext context, Exception error) {
    if (error is SocketException || error is DioException) {
      return "Check your network Connection";
    } else if (error is ParseException) {
      return "Parse Error";
    } else if (error is UnauthenticatedException) {
      return "this account be come unauthenticated please login again";
    } else if (error is MessageException) {
      return error.toString();
    } else if (error is NetError) {
      return error.toString();
    } else {
      return error.toString();
    }
  }

  /// navigate to login screen
  void navigateToLogin(BuildContext? context) {
    if (context == null) return;

    Future.delayed(Duration(seconds: 2), () {
      repository.removeToken().then((value) async {
        // navigatorWithNavBarAndKeepStack(context, SignInScreen(),
        //    showNavBar: false );
      });
    });
  }
}
