import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color notWhite = Color.fromARGB(255, 24, 24, 24); // Dark background
static const Color nearlyWhite = Color.fromARGB(255, 28, 28, 28); // Slightly brighter background
static const Color white = Color.fromARGB(255, 18, 18, 18); // Very dark tone
static const Color nearlyBlack = Color.fromARGB(255, 192, 194, 194); // Muted dark for contrast
static const Color grey = Color.fromARGB(255, 142, 144, 145); // Soft grey for elements
static const Color dark_grey = Color.fromARGB(255, 207, 207, 207); // Darker grey background

// Updated lighter text colors
static const Color darkText = Color(0xFFCCCCCC); // Light grey for regular text
static const Color darkerText = Color(0xFFBFBFBF); // Slightly darker but still bright grey
static const Color lightText = Color.fromARGB(255, 240, 239, 239); // Very light grey for emphasis
static const Color deactivatedText = Color(0xFF999999); // Muted lighter grey for disabled text
static const Color dismissibleBackground = Color(0xFF28343C); // Dark background for swipe actions
static const Color chipBackground = Color(0xFF2E3A43); // Dark chip background
static const Color spacer = Color(0xFF1F1F1F); // Dark spacer color for sections

  static const String fontName = 'WorkSans';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle( // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle( // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle( // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle( // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle( // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle( // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle( // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

}
