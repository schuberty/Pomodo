import 'package:flutter/widgets.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import 'presentation/home_page.dart';

class HomeModule extends AppModule {
  const HomeModule();

  @override
  final name = 'home';

  @override
  final path = '/home';

  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}
