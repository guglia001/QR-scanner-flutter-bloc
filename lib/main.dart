import 'package:flutter/material.dart';
import 'package:restaurant_menu_scanner/src/recent_scans_page.dart';
import 'package:wakelock/wakelock.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            floatingActionButtonTheme:
                FloatingActionButtonThemeData(backgroundColor: Colors.white70)),
        title: 'Restaurat menu scanner',
        home: Scaffold(

            body: SafeArea(child: RecentScans())));
  }
}
