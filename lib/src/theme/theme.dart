import 'package:chaseapp/src/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getThemeData(context) => ThemeData.from(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primaryColor,
        // cardColor: Color(0xFF4627a0),
        // backgroundColor: Color(0xFF4627a0),
        cardColor: Color(0xffede7f6),
        // errorColor: Color(0xFF8181de),
        accentColor: Color(0xFFFF8EC6),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      ),
    ).copyWith(
      dividerColor: primaryColor,
    );

//  ThemeData(
//     primarySwatch: Color(value),
//     primaryColor: ,
//     brightness: ,
//     colorScheme: Colors,
//     visualDensity: VisualDensity.adaptivePlatformDensity,
//     scaffoldBackgroundColor: Colors.grey[100],
//     backgroundColor: Colors.white,
//     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//     cardTheme: const CardTheme(
//         shadowColor: Colors.transparent,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(20)))),
//     appBarTheme: AppBarTheme(
//       iconTheme: const IconThemeData(color: primaryColor),
//       color: Theme.of(context).canvasColor,
//     ),
//     inputDecorationTheme: const InputDecorationTheme(
//       border: UnderlineInputBorder(),
//     ),
//     iconTheme: const IconThemeData(color: primaryColor),
//     snackBarTheme: const SnackBarThemeData(
//         backgroundColor: primaryColor,
//         contentTextStyle: TextStyle(color: Colors.white)),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         unselectedItemColor: Colors.grey,
//         selectedItemColor: Theme.of(context).primaryColor),
//     textTheme: GoogleFonts.poppinsTextTheme(
//       Theme.of(context).textTheme,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//       padding: const EdgeInsets.all(10),
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10))),
//     )),
//     buttonTheme: ButtonThemeData(
//         height: 100,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(20))),
//         buttonColor: primaryColor,
//         textTheme: ButtonTextTheme.primary));
