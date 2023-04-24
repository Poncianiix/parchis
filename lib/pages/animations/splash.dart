import 'dart:async';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shimmer/shimmer.dart';

import '../dados_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return Timer(const Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DadosPage()));
  }

  @override
  void dispose() {
    super.dispose();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.lime, Colors.lightBlue],
            ),
          ),
          child: Shimmer.fromColors(
            baseColor: const Color(0xff7f00ff),
            highlightColor: const Color(0xffe100ff),
            child: Text(
              'Let\'s play',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 60,
                shadows: <Shadow>[
                  Shadow(
                    blurRadius: 18,
                    color: Colors.black87,
                    offset: Offset.fromDirection(90, 2),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
