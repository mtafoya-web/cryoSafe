import 'package:flutter/gestures.dart';
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
        scrollBehavior: const _CryoSafeScrollBehavior(),
        home: const MainScreen(),
      ),
    );
  }
}

class _CryoSafeScrollBehavior extends MaterialScrollBehavior {
  const _CryoSafeScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return Scrollbar(
      controller: details.controller,
      thumbVisibility: true,
      child: child,
    );
  }
}
