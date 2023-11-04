import 'package:flutter/material.dart';

enum SlideState { fromTop, fromBottom, fromLeft, fromRight }

Future<dynamic> navigateAndKeepStack(BuildContext context, Widget targetRoute,
    {SlideState? slideState}) async {
  switch (slideState) {
    case SlideState.fromTop:
      return Navigator.push(
        context,
        CustomVerticalSlidePageRoute(
            builder: (context) => targetRoute, slideFromTop: true),
      );

    case SlideState.fromBottom:
      return Navigator.push(
        context,
        CustomVerticalSlidePageRoute(
            builder: (context) => targetRoute, slideFromTop: false),
      );

    case SlideState.fromLeft:
      return Navigator.push(
        context,
        CustomHorizontalSlidePageRoute(
            builder: (context) => targetRoute, slideFromRight: false),
      );

    case SlideState.fromRight:
      return Navigator.push(
        context,
        CustomHorizontalSlidePageRoute(
            builder: (context) => targetRoute, slideFromRight: true),
      );

    default:
      return Navigator.push(
        context,
        CustomHorizontalSlidePageRoute(
          builder: (context) => targetRoute,
          slideFromRight: false,
          // slideFromRight: GlobalVars.appLanguage != "ar",
        ),
      );
  }
}

Future<dynamic> navigateAndClearStack(
        BuildContext context, Widget targetRoute) =>
    Navigator.of(context).pushAndRemoveUntil(
      CustomHorizontalSlidePageRoute(
        builder: (context) => targetRoute,
        slideFromRight: false,
        // slideFromRight: GlobalVars.appLanguage == "ar",
      ),
      (Route<dynamic> route) => false,
    );

class CustomHorizontalSlidePageRoute<T> extends MaterialPageRoute<T> {
  CustomHorizontalSlidePageRoute(
      {required WidgetBuilder builder,
      RouteSettings? settings,
      this.slideFromRight = false})
      : super(builder: builder, settings: settings);
  bool slideFromRight;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: animation.drive(Tween(
              begin: Offset(slideFromRight ? -1 : 1, 0.0),
              end: Offset(0.0, 0.0))
          .chain(CurveTween(curve: Curves.ease))),
      child: child,
    );
  }
}

class CustomVerticalSlidePageRoute<T> extends MaterialPageRoute<T> {
  CustomVerticalSlidePageRoute(
      {required WidgetBuilder builder,
      RouteSettings? settings,
      this.slideFromTop = false})
      : super(builder: builder, settings: settings);
  bool slideFromTop;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: animation.drive(Tween(
              begin: Offset(0.0, slideFromTop ? -1 : 1), end: Offset(0.0, 0.0))
          .chain(CurveTween(curve: Curves.ease))),
      child: child,
    );
  }
}
