import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pomodo_commons/pomodo_commons.dart';

import 'core/app_router.dart';

class PomodoApp extends StatelessWidget {
  const PomodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.of(context);

    return MaterialApp.router(
      theme: AppThemes.lightThemeData,
      routerConfig: router.goRouter,
      locale: TranslationProvider.of(context).flutterLocale,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      onGenerateTitle: (context) => Translations.of(context).appTitle,
    );
  }
}
