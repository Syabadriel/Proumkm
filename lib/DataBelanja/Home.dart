// ignore_for_file: file_names, unnecessary_import, prefer_const_constructors_in_immutables, avoid_print, prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables, unused_import
import 'package:flutter/material.dart';
import 'package:proumkm/DataBelanja/posts.dart';
import 'package:proumkm/screens/form_belanja.dart';
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
  String nip = "";
  late Future<List<Posts>> futurePosts;

  Future<List<Posts>> fetchPosts(String nip) async {
    final response = await http.post(
      Uri.parse('https://proumkm.madiunkota.go.id/api/proumkm/belanja/pegawai'),
      headers: {"passcode": "k0taPendekArr"},
      body: {"nip": nip},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResult = jsonDecode(response.body);
      final List<dynamic> data = jsonResult['data'];
      return data.map((item) => Posts.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data belanja. Status: ${response.statusCode}');
    }
  }

  Future<void> getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final isLogin = pref.getBool("is_login") ?? false;
    if (isLogin) {
      final savedNip = pref.getString("email") ?? "";
      setState(() {
        nip = savedNip;
        futurePosts = fetchPosts(nip);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF3629B7),
        elevation: 0,
        title: const Text(
          'Rekap Detail Belanja',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: nip.isEmpty
              ? _buildLoadingIndicator()
              : FutureBuilder<List<Posts>>(
            future: futurePosts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingIndicator();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final post = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: PostCard(posts: post),
                    );
                  },
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.inbox, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        "Tidak ada data belanja ditemukan.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4DA3FF),
        unselectedItemColor: Color(0xFF4DA3FF),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: "Kembali",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Belanja",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => RegisterPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => UploadPage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF3629B7),
      ),
    );
  }
}