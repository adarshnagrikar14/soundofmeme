import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundofmeme/dashboard.dart';
import 'package:soundofmeme/login.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white70,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await getToken();
    Timer(
      const Duration(milliseconds: 1500),
      () {
        if (token != null && token.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainDashboard(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignupPage(),
            ),
          );
        }
      },
    );
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 23, 42),
      body: Opacity(
        opacity: 0.8,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 55.0, bottom: 60),
              child: Positioned.fill(
                child: Image.asset(
                  "assets/gifs/w1.gif",
                ),
              ),
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 50,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/images/w2.png",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
