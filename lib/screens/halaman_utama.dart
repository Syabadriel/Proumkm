//import 'dart:html';

// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables, avoid_unnecessary_containers, non_constant_identifier_names, avoid_types_as_parameter_names, unused_import, duplicate_import, unnecessary_import, unused_field, avoid_print, must_call_super, unnecessary_string_interpolations, use_build_context_synchronously

import 'dart:core';
// import 'dart:html';
import 'package:aplikasi_pertama/screens/form_belanja.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:aplikasi_pertama/constans.dart';
import 'package:aplikasi_pertama/DataBelanja/Home.dart';
import 'package:aplikasi_pertama/DataBelanja/posts.dart';
import 'package:aplikasi_pertama/DataBelanja/postCard.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aplikasi_pertama/screens/halaman_utama.dart';
import 'package:aplikasi_pertama/screens/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_pertama/apifolders/dialogs.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = "/registerPage";
  final _formKey = GlobalKey<FormState>();

  // final Posts posts;
  RegisterPage({Key? key}) : super(key: key);
// const RegisterPage({Key? key2, required this.totall}) : super(key: key2);
  // const RegisterPage({Key? key, required this.posts}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _counter = 0;
  final _formKey = GlobalKey<FormState>();

//   Future<List> fetchPosts() async {
//     final result = await Future.wait([
//       http.get(Uri.parse(
//         'https://proumkm.madiunkota.go.id/api/proumkm/belanja/pegawai',
//       )),
//       http.get(Uri.parse(
//           'https://proumkm.madiunkota.go.id/api/proumkm/total/belanja/pegawai')),
//     ]);
//     Map<String, String> headers = {
//       "passcode": "k0taPendekArr",
//       'Content-Type': 'application/json',
//     };
//     Map<String, String> body = {
//       "nip": email,
//     };
//     // print(result);
//     print(result);
//  print(response.body);

//     if (result == 200) {
//       final result1 = jsonDecode(result[0].body) as List<dynamic>;
//       final result2 = jsonDecode(result[1].body) as List<dynamic>;
//       result1.addAll(result2);

//       return result1;
//     } else {
//       throw Exception('Failed to load Posts');
//     }
//   }

  Future<List<Posts>> fetchPosts() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("nip", email);
    var response = await http.post(
      Uri.parse(
          'https://proumkm.madiunkota.go.id/api/proumkm/total/belanja/pegawai'),

      headers: {
        "passcode": "k0taPendekArr",
      },
      // body: {
      //   "nip": "197712172011011004",
      // }
      body: {
        "nip": email,
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResult = jsonDecode(response.body);

      List<Posts> posts = (jsonResult['data'] as List<dynamic>)
          .map((data) => Posts.fromJson(data))
          .toList();
      return posts;
    } else {
      throw Exception('Failed to load Posts');
    }
  }

  // Future<List<Posts>> fetchtotal() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   await pref.setString("nip", email);
  //   var response = await http.post(
  //     Uri.parse(
  //         'https://proumkm.madiunkota.go.id/api/proumkm/total/belanja/pegawai'),

  //     headers: {
  //       "passcode": "k0taPendekArr",
  //     },
  //     // body: {
  //     //   "nip": "197712172011011004",
  //     // }
  //     body: {
  //       "nip": email,
  //     },
  //   );

  //   print(response.statusCode);
  //   print(response.body);

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonResult = jsonDecode(response.body);

  //     List<Posts> total = (jsonResult as List<dynamic>)
  //         .map((data) => Posts.fromJson(data))
  //         .toList();
  //     return total;
  //   } else {
  //     throw Exception('Failed to load Posts');
  //   }
  // }

  String email = "";
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      setState(() {
        email = pref.getString("email")!;
      });
    }
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("is_login");
      preferences.remove("email");
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      ),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
        "Berhasil logout",
        style: TextStyle(fontSize: 16),
      )),
    );
  }

  // late Future<List> futurePosts;
  late Future<List<Posts>> futurePosts;
  // late Future<List<Posts>> futureTotal;

  @override
  void initState() {
    getPref();
    futurePosts = fetchPosts();
    // futureTotal = fetchtotal();
    _counter++;
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Posts posts;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.cyan.shade300,
              Colors.white,
            ],
          )),
          padding: EdgeInsets.zero,
          child: ListView(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    _appbar(),
                    _cardtotal(context),
                    _cardhariini(),
                    _cardmingguini(),
                    _cardbulanini(),
                    _tambah(context),
                    _txthistory(),
                    _table(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(141, 139, 149, 140),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterPage()));
          // setState(() {
          //   futurePosts = fetchPosts();
          // });
          // Respond to button press
        },
        icon: Icon(Icons.refresh),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        label: Text('R'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _appbar() {
    return AppBar(
      leading: Icon(
        (Icons.home_filled),
        color: Color.fromARGB(255, 21, 165, 255),
        shadows: <Shadow>[
          Shadow(
            offset: Offset(0, 0),
            blurRadius: 2,
            color: Color.fromARGB(127, 0, 0, 0),
          ),
        ],
      ),
      title: Text(
        ("Dashboard"),
        style: TextStyle(
          color: Color.fromARGB(255, 21, 165, 255),
          fontSize: 25.0,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(0, 0),
              blurRadius: 2,
              color: Color.fromARGB(127, 0, 0, 0),
            ),
          ],
        ),
        textAlign: TextAlign.left,
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      titleSpacing: 2,
    );
  }

  Widget _cardtotal(BuildContext context) {
    final Posts posts;
    return
        // Container(
        //   padding: const EdgeInsets.all(10.0),
        //   width: 500,
        //   height: 80,
        //   decoration: BoxDecoration(
        //       color: Color.fromARGB(208, 255, 255, 255),
        //       shape: BoxShape.rectangle,
        //       boxShadow: [
        //         BoxShadow(
        //           color: Color.fromARGB(62, 19, 19, 19),
        //           spreadRadius: 2,
        //           blurRadius: 1.5,
        //           offset: Offset(0, 0),
        //         )
        //       ]),
        //   child: Card(
        //     child: ListTile(
        //       leading: Icon(Icons.message, size: 20.0),
        //       title: Text(
        //         'Rp. 0',
        //         style: TextStyle(
        //             fontSize: 25,
        //             fontWeight: FontWeight.bold,
        //             color: Color.fromARGB(255, 49, 48, 48)),
        //       ),
        //     ),
        //   ),
        // );
        Card(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: 500,
        height: 80,
        decoration: BoxDecoration(
            color: Color.fromARGB(208, 255, 255, 255),
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(62, 19, 19, 19),
                spreadRadius: 2,
                blurRadius: 1.5,
                offset: Offset(0, 0),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //YANG PERTAMA ADALAH TOTAL DATA
            Text(
              'Rp. 0',
              //  posts.total_belanja,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 49, 48, 48)),
            ),
            //DAN YANG KEDUA ADALAH LABEL DATA
            Text(
              "Total Belanja Anda",
              // label,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: Color.fromARGB(255, 49, 48, 48),
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.5, 1.5),
                    blurRadius: 2.5,
                    color: Color.fromARGB(127, 0, 0, 0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardhariini() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: 500,
        height: 80,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 33, 219, 170),
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(62, 19, 19, 19),
                spreadRadius: 2,
                blurRadius: 1.5,
                offset: Offset(0, 0),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //YANG PERTAMA ADALAH TOTAL DATA
            Text(
              'Rp. 0',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
            //DAN YANG KEDUA ADALAH LABEL DATA
            Text(
              "Hari ini",
              // label,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: Color.fromARGB(255, 255, 255, 255),
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.5, 1.5),
                    blurRadius: 2.5,
                    color: Color.fromARGB(127, 0, 0, 0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardmingguini() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: 500,
        height: 80,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 255, 242),
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(62, 19, 19, 19),
                spreadRadius: 2,
                blurRadius: 1.5,
                offset: Offset(0, 0),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //YANG PERTAMA ADALAH TOTAL DATA
            Text(
              'Rp. 0',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
            //DAN YANG KEDUA ADALAH LABEL DATA
            Text(
              "Minggu Ini",
              // label,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: Color.fromARGB(255, 255, 255, 255),
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.5, 1.5),
                    blurRadius: 2.5,
                    color: Color.fromARGB(127, 0, 0, 0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardbulanini() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: 500,
        height: 80,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 189, 65),
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(62, 19, 19, 19),
                spreadRadius: 2,
                blurRadius: 1.5,
                offset: Offset(0, 0),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //YANG PERTAMA ADALAH TOTAL DATA
            Text(
              'Rp. 30.000',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
            //DAN YANG KEDUA ADALAH LABEL DATA
            Text(
              "Bulan Ini",
              // label,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: Color.fromARGB(255, 255, 255, 255),
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.5, 1.5),
                    blurRadius: 2.5,
                    color: Color.fromARGB(127, 0, 0, 0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _table(BuildContext context) => FutureBuilder<List<Posts>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 30.0,
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(
                      'No',
                      // style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Nama',
                      // style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Keterangan',
                      // style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Nominal',
                      // style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  // DataColumn(
                  //   label: Text(
                  //     'Details',
                  //     // style: TextStyle(fontStyle: FontStyle.italic),
                  //   ),
                  // ),
                ],
                rows: snapshot.data!.map<DataRow>((e) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text('${_counter++}')),
                      DataCell(Text('${e.nama}')),
                      DataCell(Text('${e.rekap_belanja}')),
                      DataCell(Text('${e.jumlah_uang}')),
                      // DataCell(Text('${e.jumlah_uang}')),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      });

  Widget _tambah(BuildContext context) {
    List<Widget> children = [];
    final _formKey = GlobalKey<FormState>();
    var green;
    var yellow;
    var red;
    return Padding(
        padding: EdgeInsets.zero,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.zero,
              // ignore: unnecessary_new
              child: ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff03dac6)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Tambah Belanja",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Icon(Icons.add_shopping_cart_rounded, size: 20),
                        ],
                      ),
                      onPressed: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => UploadPage());
                        Navigator.push(context, route);
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 189, 65)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Detail Belanja"),
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Icon(Icons.line_weight_sharp, size: 20)
                        ],
                      ),
                      onPressed: () {
                        Route route =
                            MaterialPageRoute(builder: (context) => Home());
                        Navigator.push(context, route);
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                      }),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 37, 37)),
                      onPressed: () {
                        logOut();
                        // Respond to button press
                      },
                      icon: Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 20,
                      ),
                      label: Text('Keluar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
    // child: ElevatedButton.icon(
    //     label: Text(
    //       'Tambah Belanja',
    //       style: TextStyle(
    //         color: Color.fromARGB(255, 255, 255, 255),
    //         fontSize: 18.0,
    //         shadows: <Shadow>[
    //           Shadow(
    //             offset: Offset(1.5, 1.5),
    //             blurRadius: 2.5,
    //             color: Color.fromARGB(127, 0, 0, 0),
    //           ),
    //         ],
    //       ),
    //     ),
    //     icon: Icon(Icons.add_shopping_cart_sharp),
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: Color.fromARGB(255, 9, 169, 255),
    //       minimumSize: const Size(300, 55),
    //       maximumSize: const Size(300, 55),
    //     ),
    //     onPressed: () {
    //       Route route = MaterialPageRoute(builder: (context) => Home());
    //       Navigator.push(context, route);
    //       // If the form is valid, display a snackbar. In the real world,
    //       // you'd often call a server or save the information in a database.
    //     }),
  }

  // Widget _btnlogout(BuildContext context) {
  //   return FloatingActionButton.extended(
  //     onPressed: () {
  //       logOut();
  //       // Respond to button press
  //     },
  //     backgroundColor: const Color(0xff03dac6),
  //     foregroundColor: Colors.black,
  //     icon: Icon(
  //       Icons.arrow_back_ios_new,
  //       size: 15,
  //     ),
  //     label: Text('Keluar'),
  //   );
  // }

  Widget _txthistory() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Text(
            "History Belanja: ",
            style: TextStyle(fontSize: 20),
          ),
          // Text("$email", style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 15),
          // Padding(padding: EdgeInsets.only(left: 60)),
          // FloatingActionButton(
          //   onPressed: () {
          //     setState(() {
          //       futurePosts = fetchPosts();
          //     });
          //   },
          //   child: Icon(Icons.refresh),
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(20.0))),
          // ),

          const SizedBox(height: 15),
          Padding(padding: EdgeInsets.only(left: 10)),
        ],
      ),
    );
  }
}
