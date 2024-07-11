import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/app_widget.dart';
import 'src/core/app_provider.dart';
import 'src/core/app_router.dart';
import 'src/modules/app_modules.dart';
import 'src/modules/home/home_module.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    AppProvider(
      child: AppRouter(
        modules: appModules,
        initialRoute: const HomeModule().path,
        child: const PomodoApp(),
      ),
    ),
  );
}
