import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primarySwatch: Colors.brown,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color.fromARGB(255, 138, 101, 88),
      secondary: Colors.brown[100]!,
      background: Colors.brown[50]!,
      tertiary: Color.fromARGB(255, 138, 101, 88),
      surface: Color.fromARGB(255, 138, 101, 88),
      // Add other color scheme properties as needed
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.brown,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        color: Colors.brown[100],
        fontWeight: FontWeight.bold,
      ),
      headline1: TextStyle(
        color: Color.fromARGB(255, 138, 101, 88),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Color.fromARGB(219, 158, 126, 114),
        fontSize: 13,
      ),
      headline3: TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
      headline4: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      headline5: TextStyle(
        color: Colors.grey[200],
        fontSize: 16.0,
        // fontWeight: FontWeight.bold,
      ),
    ),
  );
  /*
  TextStyle(
    color: Colors.black,
    fontSize: MediaQuery.of(context).size.width * 0.04,
    fontWeight: FontWeight.bold,
  */

  static final darkTheme = ThemeData(
    primarySwatch: Colors.brown,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.black,
      secondary: Colors.grey[700]!,
      background: Color.fromARGB(255, 45, 43, 43),
      tertiary: Colors.grey[100],
      surface: Colors.grey[700]!,
      // Add other color scheme properties as needed
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        color: Colors.grey[300],
        fontWeight: FontWeight.bold,

      ),
      headline1: TextStyle(
        color: Colors.grey[300],
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Colors.grey[400],
        fontSize: 13,
      ),
      headline3: TextStyle(
        color: Colors.grey[300],
        fontSize: 15,
      ),
      headline4: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      headline5: TextStyle(
        color: Colors.grey[200],
        fontSize: 16.0,
        // fontWeight: FontWeight.bold,
      ),
    ),
  );
}
