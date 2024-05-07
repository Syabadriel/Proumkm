// ignore_for_file: prefer_const_constructors, camel_case_types, non_constant_identifier_names, unnecessary_import
import 'package:flutter/material.dart';
import 'dart:ui';

class Colours {
  Colours._();

  static Color blue = const Color(0xff5e6ceb);

  static Color blueDark = const Color(0xff4D5DFB);
}

Color primaryBlue = Color.fromARGB(255, 107, 28, 204);
Color textBlack = Color(0xff222222);
Color textGrey = Color(0xff94959b);
Color textWhiteGrey = Color(0xfff1f1f5);
Color primaryBlack = Color(0xff222222);

TextStyle heading2 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
);

TextStyle heading5 = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

TextStyle heading6 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

TextStyle regular16pt = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

class ColorPalette {
  static const primaryColor = Color.fromARGB(255, 255, 255, 255);
  static const primaryDarkColor = Color.fromARGB(255, 11, 11, 11);
  static const underlineTextField = Color.fromARGB(255, 12, 12, 12);
  static const hintColor = Color.fromARGB(255, 8, 8, 8);
}

class resep {
  String name, htm, tutorial, image;

  resep(
      {required this.name,
      required this.htm,
      required this.tutorial,
      required this.image});
}

// class Name {
//   String no;
//   String keterangan;
//   String nominal;
//   String foto1;
//   String foto2;
//   String foto3;

//   Name({
//     required this.no,
//     required this.keterangan,
//     required this.nominal,
//     required this.foto1,
//     required this.foto2,
//     required this.foto3,
//   });
// }

// // Data Model
// var Names = <Name>[
//   Name(
//       no: "1",
//       keterangan: "ridwan",
//       nominal: "300",
//       foto1: "",
//       foto2: "",
//       foto3: ""),
//   Name(
//       no: "2",
//       keterangan: "ridwan",
//       nominal: "300",
//       foto1: "",
//       foto2: "",
//       foto3: ""),
//   Name(
//       no: "3",
//       keterangan: "ridwan",
//       nominal: "300",
//       foto1: "",
//       foto2: "",
//       foto3: ""),
//   Name(
//       no: "4",
//       keterangan: "ridwan",
//       nominal: "300",
//       foto1: "",
//       foto2: "",
//       foto3: ""),
//   Name(
//       no: "5",
//       keterangan: "ridwan",
//       nominal: "300",
//       foto1: "",
//       foto2: "",
//       foto3: ""),
//   Name(
//       no: "6",
//       keterangan: "ridwan",
//       nominal: "300",
//       foto1: "",
//       foto2: "",
//       foto3: ""),
//   Name(
//       no: "7",
//       keterangan: "ridwan",
//       nominal: "300",
//       foto1: "",
//       foto2: "",
//       foto3: ""),
//   Name(
//       no: "8",
//       keterangan: "ridwan",
//       nominal: "300",
//       foto1: "",
//       foto2: "",
//       foto3: ""),
// ];
//   factory Name.fromJson(Map<String, dynamic> json) => Name(
//         no: json['no'],
//         keterangan: json['keterangan'],
//         nominal: json['nominal'],
//         foto1: json['foto1'],
//         foto2: json['foto2'],
//         foto3: json['foto3'],
//       );
// }
