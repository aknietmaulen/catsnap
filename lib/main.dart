import 'package:flutter/material.dart';
import 'package:catsnap/initial_screen.dart';



void main()
{
  runApp(const CatSnap());
}

class CatSnap extends StatelessWidget {
  const CatSnap({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme:const AppBarTheme(color: Color.fromARGB(255, 174, 216, 251)),
        scaffoldBackgroundColor: const Color(0xFF000000),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color.fromARGB(255, 207, 91, 227)),
        textTheme:const TextTheme(bodyMedium: TextStyle(color: Colors.black,fontFamily: 'sans')),
      ),
       home: const SplashScreen(),
    );
  }
}
