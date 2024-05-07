// // ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables, avoid_unnecessary_containers, non_constant_identifier_names, avoid_types_as_parameter_names, unused_import, duplicate_import, unnecessary_import, unused_field, avoid_print, must_call_super, unnecessary_string_interpolations, use_build_context_synchronously

// import 'dart:core';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:proumkm/screens/form_belanja.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/foundation.dart';
// import 'package:proumkm/constans.dart';
// import 'package:proumkm/DataBelanja/Home.dart';
// import 'package:proumkm/DataBelanja/posts.dart';
// import 'package:proumkm/DataBelanja/postCard.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:proumkm/screens/halaman_utama.dart';
// import 'package:proumkm/screens/login_view.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:proumkm/apifolders/dialogs.dart';
// // import 'package:flutter_animated_cards/flutter_animated_cards.dart';
// import 'package:animated_card/animated_card.dart';

// class AnimatedCardGroup extends StatefulWidget {
//   @override
//   _AnimatedCardGroupState createState() => _AnimatedCardGroupState();
// }

// class _AnimatedCardGroupState extends State<AnimatedCardGroup> {


//   int _counter = 0;
//   final _formKey = GlobalKey<FormState>();

//   String totalBelanja = '';
//   String totalHariIni = '';
//   String totalMingguIni = '';
//   String totalBulanIni = '';

//   @override
//   void initState() {
//     super.initState();
//     _counter++;
//     fetchData();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     getPref();
//   }

//   String email = "";
//   getPref() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var islogin = pref.getBool("is_login");
//     if (islogin != null && islogin == true) {
//       setState(() {
//         email = pref.getString("email")!;
//       });
//     }
//   }

//   Future<void> fetchData() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.setString("nip", email);

//     final response = await http.post(
//       Uri.parse(
//           'https://proumkm.madiunkota.go.id/api/proumkm/total/belanja/pegawai'),
//       headers: {
//         'passcode': 'k0taPendekArr',
//       },
//       body: {
//         "nip": email,
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);

//       setState(() {
//         totalBelanja = data['total_belanja'] ?? '';
//         totalHariIni = data['total_hari_ini'] ?? '';
//         totalMingguIni = data['total_minggu_ini'] ?? '';
//         totalBulanIni = data['total_bulan_ini'] ?? '';
//       });
//     } else {
//       // Handle error response
//       print('Error: ${response.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         AnimatedCard(
//           direction: AnimatedCardDirection
//               .right, // Ganti dengan arah animasi yang diinginkan
//           child: _cardtotal(),
//         ),
//         SizedBox(height: 10),
//         AnimatedCard(
//           direction: AnimatedCardDirection
//               .left, // Ganti dengan arah animasi yang diinginkan
//           child: _cardhariini(),
//         ),
//         SizedBox(height: 10),
//         AnimatedCard(
//           direction: AnimatedCardDirection
//               .right, // Ganti dengan arah animasi yang diinginkan
//           child: _cardmingguini(),
//         ),
//         SizedBox(height: 10),
//         AnimatedCard(
//           direction: AnimatedCardDirection
//               .left, // Ganti dengan arah animasi yang diinginkan
//           child: _cardbulanini(),
//         ),
//       ],
//     );
//   }

//   Widget _cardtotal() {
//     return Card(
//       child: Container(
//         padding: const EdgeInsets.all(10.0),
//         width: 500,
//         height: 80,
//         decoration: BoxDecoration(
//           color: Colors.blue, // Ganti dengan warna yang diinginkan
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Row(
//           children: <Widget>[
//             Icon(
//               Icons.tour_sharp,
//               size: 40,
//               color: Colors.white,
//             ),
//             SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     totalBelanja,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color:
//                           Colors.white, // Ganti dengan warna teks yang sesuai
//                     ),
//                   ),
//                   Text(
//                     "Total Belanja Anda",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color:
//                           Colors.white, // Ganti dengan warna teks yang sesuai
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _cardhariini() {
//     return Card(
//       child: Container(
//         padding: const EdgeInsets.all(10.0),
//         width: 500,
//         height: 80,
//         decoration: BoxDecoration(
//           color: Colors.green, // Ganti dengan warna yang diinginkan
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Row(
//           children: <Widget>[
//             Icon(
//               Icons.calendar_today,
//               color: Colors.white, // Ganti dengan warna ikon yang sesuai
//             ),
//             SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     totalHariIni,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color:
//                           Colors.white, // Ganti dengan warna teks yang sesuai
//                     ),
//                   ),
//                   Text(
//                     "Hari ini",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color:
//                           Colors.white, // Ganti dengan warna teks yang sesuai
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _cardmingguini() {
//     return Card(
//       child: Container(
//         padding: const EdgeInsets.all(10.0),
//         width: 500,
//         height: 80,
//         decoration: BoxDecoration(
//           color: Colors.orange, // Ganti dengan warna yang diinginkan
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Row(
//           children: <Widget>[
//             Icon(
//               Icons.calendar_view_week,
//               color: Colors.white, // Ganti dengan warna ikon yang sesuai
//             ),
//             SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     totalMingguIni,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color:
//                           Colors.white, // Ganti dengan warna teks yang sesuai
//                     ),
//                   ),
//                   Text(
//                     "Minggu Ini",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color:
//                           Colors.white, // Ganti dengan warna teks yang sesuai
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _cardbulanini() {
//     return Card(
//       child: Container(
//         padding: const EdgeInsets.all(10.0),
//         width: 500,
//         height: 80,
//         decoration: BoxDecoration(
//           color: Colors.red, // Ganti dengan warna yang diinginkan
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Row(
//           children: <Widget>[
//             Icon(
//               Icons.calendar_today,
//               color: Colors.white, // Ganti dengan warna ikon yang sesuai
//             ),
//             SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     totalBulanIni,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color:
//                           Colors.white, // Ganti dengan warna teks yang sesuai
//                     ),
//                   ),
//                   Text(
//                     "Bulan Ini",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color:
//                           Colors.white, // Ganti dengan warna teks yang sesuai
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
