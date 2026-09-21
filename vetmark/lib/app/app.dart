import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

class VetMarkApp extends StatelessWidget {
  const VetMarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VetMark',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.theme,

      initialRoute: AppRoutes.splash,

      routes: AppRoutes.routes,
    );
  }
}