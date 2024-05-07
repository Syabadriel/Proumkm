// ignore_for_file: file_names, unnecessary_import, prefer_const_constructors_in_immutables, avoid_print, must_call_super, prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables, unused_import
import 'package:flutter/material.dart';
import 'package:proumkm/DataBelanja/posts.dart';
import 'package:flutter/services.dart';
import 'package:proumkm/screens/halaman_utama.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:proumkm/DataBelanja/postCard.dart';
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
      appBar: AppBar(
        backgroundColor:
            Colors.blueGrey[100], // Warna latar belakang yang kalem
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
        title: Text(
          'Rekap Data',
          style: TextStyle(
            color: Colors.black, // Warna teks judul
            fontSize: 20, // Ukuran teks judul
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined, // Icon untuk menu navigasi
            color: Colors.black, // Warna ikon
          ),
          onPressed: () {
            Navigator.pop(context);
            // Aksi ketika ikon menu diklik
          },
        ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.search, // Icon untuk pencarian
          //     color: Colors.black, // Warna ikon
          //   ),
          //   onPressed: () {
          //     // Aksi ketika ikon pencarian diklik
          //   },
          // ),
          // IconButton(
          //   icon: Icon(
          //     Icons.filter_list, // Icon untuk filter
          //     color: Colors.black, // Warna ikon
          //   ),
          //   onPressed: () {
          //     // Aksi ketika ikon filter diklik
          //   },
          // ),
        ],
      ),
      body: SafeArea(
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
