import 'package:flutter/services.dart';

import '../../index.dart';
import '../utils/constants.dart';

class AppTheme {
  // TODO:[Chanage Theme]
  static final lightTheme = ThemeData(
    primaryColor: Constants.mainColor,
    colorScheme: const ColorScheme.light(
      primary: Constants.mainColor,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      constraints: BoxConstraints.tightForFinite(
        width: 90.w,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Constants.mainColor,
        side: const BorderSide(
          color: Constants.mainColor,
          width: 0.8,
        ),
        minimumSize: const Size.fromHeight(44),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    ),
  );
}
