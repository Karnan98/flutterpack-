import 'package:flutter/material.dart';
import 'package:outdoor_pod/router.dart';

import 'package:sizer/sizer.dart';

import 'commonstyle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OutDoor Inspection',
        theme: ThemeData(
          useMaterial3: true,
          expansionTileTheme: const ExpansionTileThemeData(
              collapsedIconColor: primarycolor,
              textColor: primarycolor,
              iconColor: Color.fromARGB(255, 20, 20, 20)),
          primaryColor: primarycolor,
          inputDecorationTheme: InputDecorationTheme(
             border: textboxOutlineprimary,
                  enabledBorder: borderenable,
                  labelStyle: textboxOutlineprimaryText,
                  focusedBorder: textboxOutlineprimaryfocus,
          ),
          appBarTheme: AppBarTheme(
              color: primarycolor,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 15.sp),
              iconTheme: const IconThemeData(color: Colors.white)),
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Colors.grey,
            cursorColor: primarycolor,
            selectionHandleColor: primarycolor,
          ),
          brightness: Brightness.light,
          highlightColor: Colors.white,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: primarycolor,
              focusColor: Color.fromARGB(255, 207, 6, 13),
              splashColor: Color.fromARGB(255, 235, 95, 100)),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: Colors.white)
              .copyWith(background: Colors.white),
        ),
        initialRoute: '/',
        routes: RouterMenu().routes,
      );
    });
  }
}
