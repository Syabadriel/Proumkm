// ignore_for_file: file_names, unnecessary_import, prefer_const_constructors_in_immutables, avoid_print, must_call_super, prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables, unused_import
import 'package:flutter/material.dart';
import 'package:aplikasi_pertama/DataBelanja/posts.dart';
import 'package:flutter/services.dart';
import 'package:aplikasi_pertama/screens/halaman_utama.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:aplikasi_pertama/DataBelanja/postCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  late Future<List<Posts>> futurePosts;

  @override
  void initState() {
    getPref();
    futurePosts = fetchPosts();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(
      //   gradient: LinearGradient(
      //       begin: Alignment.topRight,
      //       end: Alignment.bottomLeft,
      //       colors: [
      //         Colors.cyan.shade300,
      //         Colors.white,
      //       ],
      // ),
      // ),
      appBar: AppBar(
        // ignore: prefer_const_constructors
        leading: Icon(
          (Icons.line_weight_sharp),
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
          ("REKAP BELANJA"),
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
      ),
      body: SafeArea(
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
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: FutureBuilder<List<Posts>>(
                future: futurePosts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                        itemBuilder: ((context, index) {
                          var post = (snapshot.data as List<Posts>)[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PostCard(
                                posts: Posts(
                                  nip: post.nip,
                                  nama: post.nama,
                                  rekap_belanja: post.rekap_belanja,
                                  jumlah_uang: post.jumlah_uang,
                                  foto1: post.foto1,
                                  foto2: post.foto2,
                                  foto3: post.foto3,
                                  // total_belanja: post.total_belanja,
                                  // total_bulan_ini: post.total_bulan_ini,
                                  // total_hari_ini: post.total_minggu_ini,
                                  // total_minggu_ini: post.total_minggu_ini,
                                  // total_tahun_ini: post.total_tahun_ini,
                                ),
                              ),
                            ],
                          );
                        }),
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: (snapshot.data as List<Posts>).length);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return CircularProgressIndicator();
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 255, 189, 65),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.pop(context);
          // Respond to button press
        },
        icon: Icon(Icons.arrow_back),
        label: Text('Kembali'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
