import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:soundofmeme/dashboard.dart';
import 'package:soundofmeme/login.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  double _imageHeight = 50.0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _checkToken();
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _imageHeight = 300.0;
      });
    });
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
      body: Column(
        children: [
          const Spacer(),
          Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              height: _imageHeight,
              child: Image.asset(
                "assets/images/w1.png",
                errorBuilder: (context, error, stackTrace) {
                  Fluttertoast.showToast(msg: "$error");
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
