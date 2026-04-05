import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/thaw_controller.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';

class CryoSafeApp extends StatelessWidget {
  const CryoSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThawController()..recalculate(),
      child: MaterialApp(
        title: 'CryoSafe',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dashboardTheme,
        home: const MainScreen(),
      ),
    );
  }
}
