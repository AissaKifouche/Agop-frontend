import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/auth/get_started_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agop",
      debugShowCheckedModeBanner: true,

      theme: AgopTheme.lightTheme,
      home: GetStartedPage(),

    );
  }
}
