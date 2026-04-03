import 'package:flutter/material.dart';
import 'core/app_theme.dart';

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

    );
  }
}
