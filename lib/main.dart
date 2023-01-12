import 'package:flutter/material.dart';
import 'package:froncophonie/view/choice_screen.dart';
import 'package:froncophonie/view/introduction_screen.dart';
import 'package:get/get.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      title: 'village froncophonie',
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0)),
      ),
      // home: Introduction_Screen()  ,
      home: ChoiceScreen(),
    );
  }
}
