// import 'package:aplikasi_pertama/APIFOLDERS/operationAPI.dart';
// ignore_for_file: unused_import, unnecessary_new

import 'dart:io';
import 'package:aplikasi_pertama/DataBelanja/Home.dart';
import 'package:aplikasi_pertama/DataBelanja/postCard.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_pertama/screens/login_view.dart';
import 'package:aplikasi_pertama/screens/halaman_utama.dart';
import 'package:aplikasi_pertama/DataBelanja/detailPage.dart';
import 'package:aplikasi_pertama/DataBelanja/posts.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      title: "Login Register Page",
      initialRoute: "/",
      routes: {
        "/": (context) => LoginPage(),
        "/second": (context) => Home(),
        RegisterPage.routeName: (context) {
          return RegisterPage();
        },
        // "/": (context) => RegisterPage(),
        // RegisterPage.routeName: (context) => DataPage(),
      },
    ),
  );
}
