import 'package:flutter/material.dart';

class AgopTheme {
  static ThemeData lightTheme = ThemeData(
    //the main background color
    scaffoldBackgroundColor: const Color(0xFFF2EDE3),

    // the dark green color
    primaryColor: const Color(0xFF1A3D2B),

    //the color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1A3D2B), //base color of the app
      primary: const Color(0xFF1A3D2B),  //used also in headers and main buttons
      secondary: const Color(0xFF5BBF86), // used in buttons...
      surface: const Color(0xFFFDFAF5),  //used for cards
    ),
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFF1C1208),   // dark coffee color used for writing in the cards
        fontSize: 36,
      )
    ),
  );

}