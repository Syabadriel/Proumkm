// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables, avoid_unnecessary_containers, non_constant_identifier_names, avoid_types_as_parameter_names, unused_import, duplicate_import, unnecessary_import, unused_field, avoid_print, must_call_super, unnecessary_string_interpolations, use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'dart:core';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proumkm/screens/form_belanja.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:proumkm/constans.dart';
import 'package:proumkm/DataBelanja/Home.dart';
import 'package:proumkm/DataBelanja/posts.dart';
import 'package:proumkm/DataBelanja/postCard.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proumkm/screens/halaman_utama.dart';
import 'package:proumkm/screens/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proumkm/apifolders/dialogs.dart';
import 'coba.dart';
import 'package:animated_card/animated_card.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = "/registerPage";
  final _formKey = GlobalKey<FormState>();
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _counter = 1;
  final _formKey = GlobalKey<FormState>();

  String totalBelanja = '';
  String totalHariIni = '';
  String totalMingguIni = '';
  String totalBulanIni = '';
// =============================================================================
  Future<List<Posts>> fetchPosts() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("nip", email);
    var response = await http.post(
      Uri.parse('https://proumkm.madiunkota.go.id/api/proumkm/belanja/pegawai'),
      headers: {
        "passcode": "k0taPendekArr",
      },
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

  late Future<List<Posts>> futurePosts;

  @override
  void initState() {
    getPref();
    futurePosts = fetchPosts();
    // futureTotal = fetchtotal();
    // _counter;
    fetchData();
  }

  @override
  dispose() {
    super.dispose();
  }

// =============================================================================
  Future<void> fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("nip", email);

    final response = await http.post(
      Uri.parse(
          'https://proumkm.madiunkota.go.id/api/proumkm/total/belanja/pegawai'),
      headers: {
        'passcode': 'k0taPendekArr',
      },
      body: {
        "nip": email,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        totalBelanja = data['total_belanja'] ?? '';
        totalHariIni = data['total_hari_ini'] ?? '';
        totalMingguIni = data['total_minggu_ini'] ?? '';
        totalBulanIni = data['total_bulan_ini'] ?? '';
      });
    } else {
      // Handle error response
      print('Error: ${response.statusCode}');
    }
  }

// =============================================================================
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
              const Color.fromARGB(255, 255, 255, 255),
              Colors.white,
            ],
          )),
          padding: EdgeInsets.zero,
          child: ListView(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    // _appbar(),
                    _grupcard(context),
                    // _cardtotal(),
                    // _cardhariini(),
                    // _cardmingguini(),
                    // _cardbulanini(),
                    SizedBox(height: 15),
                    _tambah(context),
                    SizedBox(height: 15),
                    _txthistory(),
                    _table(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          color: Color.fromRGBO(
              0, 51, 102, 1), // Ubah warna latar belakang di sini
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(91, 0, 0, 0).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: FloatingActionButton.extended(
                  backgroundColor: Color.fromRGBO(0, 51, 102, 1),
                  foregroundColor: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UploadPage()));
                    // Kode yang akan dijalankan saat tombol ditekan
                  },
                  icon: Icon(Icons.camera_alt_outlined, size: 25),
                  label: Text(
                    'Belanja',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Widget _grupcard(BuildContext context) {
    return Column(
      children: [
        AnimatedCard(
          direction: AnimatedCardDirection
              .right, // Ganti dengan arah animasi yang diinginkan
          child: _cardtotal(),
        ),
        SizedBox(height: 10),
        AnimatedCard(
          direction: AnimatedCardDirection
              .left, // Ganti dengan arah animasi yang diinginkan
          child: _cardhariini(),
        ),
        SizedBox(height: 10),
        AnimatedCard(
          direction: AnimatedCardDirection
              .right, // Ganti dengan arah animasi yang diinginkan
          child: _cardmingguini(),
        ),
        SizedBox(height: 10),
        AnimatedCard(
          direction: AnimatedCardDirection
              .left, // Ganti dengan arah animasi yang diinginkan
          child: _cardbulanini(),
        ),
      ],
    );
  }

  Widget _cardtotal() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: 500,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue, // Ganti dengan warna yang diinginkan
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.tour_sharp,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Rp. ${totalBelanja}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors.white, // Ganti dengan warna teks yang sesuai
                    ),
                  ),
                  Text(
                    "Total Belanja Anda",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors.white, // Ganti dengan warna teks yang sesuai
                    ),
                  ),
                ],
              ),
            ),
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
          color: Colors.green, // Ganti dengan warna yang diinginkan
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.calendarDay, size: 50,
              color: Colors.white, // Ganti dengan warna ikon yang sesuai
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Rp. ${totalHariIni}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors.white, // Ganti dengan warna teks yang sesuai
                    ),
                  ),
                  Text(
                    "Belanja Hari ini",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors.white, // Ganti dengan warna teks yang sesuai
                    ),
                  ),
                ],
              ),
            ),
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
          color: Colors.orange, // Ganti dengan warna yang diinginkan
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.calendarWeek,
              size: 50,
              color: Colors.white, // Ganti dengan warna ikon yang sesuai
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Rp. ${totalMingguIni}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors.white, // Ganti dengan warna teks yang sesuai
                    ),
                  ),
                  Text(
                    "Belanja Minggu Ini",
                    style: TextStyle(
                      fontSize: 20,
                      color:
                          Colors.white, // Ganti dengan warna teks yang sesuai
                    ),
                  ),
                ],
              ),
            ),
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
          color: Colors.red, // Ganti dengan warna yang diinginkan
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.calendarAlt,
              size: 50,
              color: Colors.white, // Ganti dengan warna ikon yang sesuai
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Rp. ${totalBulanIni}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color:
                          Colors.white, // Ganti dengan warna teks yang sesuai
                    ),
                  ),
                  Text(
                    "Belanja Bulan Ini",
                    style: TextStyle(
                      fontSize: 20,
                      color:
                          Colors.white, // Ganti dengan warna teks yang sesuai
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _table(BuildContext context) => FutureBuilder<List<Posts>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(left: 1),
                child: DataTable(
                  columnSpacing: 15.0,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text(
                        'No',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Nama',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Keterangan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Nominal',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  rows: snapshot.data!.asMap().entries.map<DataRow>((entry) {
                    int index = entry.key;
                    Posts post = entry.value;
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Container(
                          width: 20,
                          child: Text(
                            '${_counter + index}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                        DataCell(Container(
                          width: 150,
                          child: Text(
                            '${post.nama}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                        DataCell(Container(
                          width: 200,
                          child: Text(
                            '${post.rekap_belanja}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                        DataCell(Text(
                          'Rp. ${post.jumlah_uang}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

  Widget _tambah(BuildContext context) {
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
                    primary: Color.fromRGBO(0, 51, 102, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (context) => Home());
                    Navigator.push(context, route);
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Detail Belanja",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.line_weight_sharp, size: 25),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(0, 51, 102, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    logOut();
                    // Respond to button press
                  },
                  icon: Icon(
                    Icons.arrow_circle_right_outlined,
                    size: 25,
                  ),
                  label: Text(
                    'Keluar',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _txthistory() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Text(
            "History Belanja: ",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 15),
          const SizedBox(height: 15),
          Padding(padding: EdgeInsets.only(left: 10)),
        ],
      ),
    );
  }
}
