import 'package:flutter/widgets.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

class AppRouter extends InheritedWidget {
  AppRouter({
    super.key,
    required this.modules,
    required this.initialRoute,
    required super.child,
  });

  final String initialRoute;
  final List<AppModule> modules;

  final navigationKey = GlobalKey<NavigatorState>();

  late final goRouter = _buildGoRouter();

  static AppRouter of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppRouter>();

    if (result == null) {
      throw Exception('AppRouter is not found in the widget tree, wrap your app with it');
    }

    return result;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  GoRouter _buildGoRouter() {
    final routes = modules.map((module) => module.toGoRoute()).toList();

    return GoRouter(
      routes: routes,
      initialLocation: initialRoute,
      navigatorKey: navigationKey,
    );
  }
}
