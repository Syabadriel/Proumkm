// import 'package:proumkm/APIFOLDERS/operationAPI.dart';
// ignore_for_file: unused_import, unnecessary_new

import 'dart:convert';
import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:proumkm/DataBelanja/Home.dart';
import 'package:proumkm/DataBelanja/detailPage.dart';
import 'package:proumkm/DataBelanja/postCard.dart';
import 'package:proumkm/DataBelanja/posts.dart';
import 'package:proumkm/screens/halaman_utama.dart';
import 'package:proumkm/screens/login_view.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProUMKM Kota Madiun',
      home: AnimatedSplashScreen(
        splash: 'assets/splash.gif',
        nextScreen: LoginPage(),
        duration: 5000,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        splashIconSize: double.infinity,
        // alignment: Alignment.topCenter,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
    ),
    // MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: "Pro-UMKM Kota Madiun",
    //   initialRoute: "/",
    //   routes: {
    //     "/": (context) => LoginPage(),
    //     "/second": (context) => Home(),
    //     RegisterPage.routeName: (context) {
    //       return RegisterPage();
    //     },
    //     // "/": (context) => RegisterPage(),
    //     // RegisterPage.routeName: (context) => DataPage(),
    //   },
    // ),
  );
}
