import 'package:flutter/material.dart';

import 'routes.dart';

class LvBeiChecklistApp extends StatelessWidget {
  const LvBeiChecklistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '旅备清单',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
