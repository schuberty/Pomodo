import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

abstract class AppModule {
  const AppModule();

  String get name;
  String get path;

  Widget builder(BuildContext context, GoRouterState state);

  GoRoute toGoRoute() {
    return GoRoute(name: name, path: path, builder: builder);
  }
}
