import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ugbussinesscard/utils/constants.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: appMatColor,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      textTheme: isDarkTheme
          ? GoogleFonts.openSansTextTheme(const TextTheme(
              bodyText1: TextStyle(color: white),
              bodyText2: TextStyle(color: white)))
          : GoogleFonts.openSansTextTheme(const TextTheme(
              bodyText1: TextStyle(color: black),
              bodyText2: TextStyle(color: black))),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 5,
      ),
      snackBarTheme: SnackBarThemeData(
          elevation: 5,
          backgroundColor: isDarkTheme == true ? black : appMatColor),
      appBarTheme: AppBarTheme(
        toolbarHeight: const Size.fromHeight(65).height,
        elevation: 1,
        backgroundColor: isDarkTheme == true ? Colors.transparent : appMatColor,
      ),
    );
  }
}
