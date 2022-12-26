import 'package:flutter/material.dart';

//the generic t here, that wuld be the data that the page you're loading would resolve to once it's popped off
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder? builder, RouteSettings? settings})
      : super(
          builder: builder!,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}


class CustomPageTransitionBuilder extends PageTransitionsBuilder {
    @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
