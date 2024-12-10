import 'package:flutter/material.dart';

var lightThemeData = ThemeData(
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.blueGrey,
    onPrimary: Colors.white,
  ),
  cardColor: Colors.blueGrey[50],
  primaryTextTheme: TextTheme(
    labelLarge: TextStyle(
      color: Colors.blueGrey,
      decorationColor: Colors.blueGrey[300],
    ),
    titleLarge: TextStyle(
      color: Colors.blueGrey[900],
    ),
    titleSmall: TextStyle(
      color: Colors.black,
    ),
    headlineMedium: TextStyle(color: Colors.blueGrey[800]),
  ),
  iconTheme: IconThemeData(color: Colors.blueGrey),
  brightness: Brightness.light, bottomAppBarTheme: BottomAppBarTheme(color: Colors.blueGrey[900]),
);

var darkThemeData = ThemeData(
  primarySwatch: Colors.blueGrey,
  colorScheme: ColorScheme.dark(
    background: Colors.blueGrey[900],
    primary: Colors.blueGrey[200] ?? Colors.blueGrey,
    onPrimary: Colors.black,
  ),
  cardColor: Colors.black,
  primaryTextTheme: TextTheme(
    labelLarge: TextStyle(
      color: Colors.blueGrey[200],
      decorationColor: Colors.blueGrey[50],
    ),
    titleSmall: TextStyle(
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      color: Colors.blueGrey[300],
    ),
    headlineMedium: TextStyle(
      color: Colors.white70,
    ),
  ),
  iconTheme: IconThemeData(color: Colors.blueGrey[200]),
  brightness: Brightness.dark, bottomAppBarTheme: BottomAppBarTheme(color: Colors.black),
);
