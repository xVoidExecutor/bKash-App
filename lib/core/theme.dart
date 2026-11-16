import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kPink = Color(0xFFE2136E);

ThemeData appTheme() => ThemeData(
      useMaterial3: true,
      colorSchemeSeed: kPink,
      scaffoldBackgroundColor: const Color(0xFFF5F5F8),
      textTheme: GoogleFonts.notoSansBengaliTextTheme(),
      appBarTheme: const AppBarTheme(
          backgroundColor: kPink, foregroundColor: Colors.white),
    );
