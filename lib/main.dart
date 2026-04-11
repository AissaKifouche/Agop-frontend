import 'package:agop/features/crops/crops_provider.dart';
import 'package:agop/features/tasks/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/auth/get_started_page.dart';
import "package:provider/provider.dart";

/*void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CropsProvider(),
      child: MyApp(),
    )
  );
}*/

void main(){
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CropsProvider()),
        ChangeNotifierProvider(create: (_) => TasksProvider()),
      ],
      child: MyApp(),
    )
  );
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
