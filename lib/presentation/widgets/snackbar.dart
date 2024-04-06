import 'package:task_manager/constants/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySnackBar extends SnackBar {
  MySnackBar({
    super.key,
    required Icon icon,
    required String message,
    required double margin,
  }) : super(
          content: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Colors.black,
                  MyColors.myred2,
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: GoogleFonts.karla(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          margin: EdgeInsets.symmetric(vertical: margin, horizontal: 6),
          elevation: 0,
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.black,
            onPressed: () {},
          ),
        );
}
