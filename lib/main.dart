import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soundofmeme/splashscreen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound of Meme',
      home: const Splashscreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 15, 23, 42),
          surface: Colors.white,
          onPrimary: Colors.white,
        ),
        textTheme: GoogleFonts.pottaOneTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
