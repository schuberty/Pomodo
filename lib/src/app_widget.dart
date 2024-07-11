import 'package:flutter/material.dart';

import 'core/app_router.dart';

class PomodoApp extends StatelessWidget {
  const PomodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.of(context);

    return MaterialApp.router(
      routerConfig: router.goRouter,
    );
  }
}
