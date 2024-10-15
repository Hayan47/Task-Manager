import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/constants/my_colors.dart';

class CustomTheme {
  static ThemeData get appTheme {
    return ThemeData(
      scaffoldBackgroundColor: MyColors.mywhite,
      primaryColor: MyColors.mywhite,
      secondaryHeaderColor: Colors.black,
      //? app bar theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: GoogleFonts.karla(
          fontWeight: FontWeight.bold,
          color: MyColors.mywhite,
          fontSize: 22,
        ),
        actionsIconTheme: const IconThemeData(
          color: MyColors.mywhite,
        ),
        iconTheme: const IconThemeData(
          color: MyColors.mywhite,
        ),
      ),
      //?text theme
      textTheme: TextTheme(
        //! 1
        bodyMedium: GoogleFonts.nunito(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        //! 2
        bodySmall: GoogleFonts.karla(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
