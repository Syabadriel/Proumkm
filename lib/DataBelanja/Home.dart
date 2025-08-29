// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:proumkm/DataBelanja/posts.dart';
import 'package:proumkm/DataBelanja/postCard.dart';
import 'package:proumkm/screens/form_belanja.dart';
import 'package:proumkm/screens/halaman_utama.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _nip = "";
  Future<List<Posts>>? _futurePosts;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  /// Fetch data dari API
  Future<List<Posts>> _fetchPosts(String nip) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://proumkm.madiunkota.go.id/api/proumkm/belanja/pegawai'),
        headers: {"passcode": "k0taPendekArr"},
        body: {"nip": nip},
      );

      if (response.statusCode == 200) {
        final jsonResult = jsonDecode(response.body) as Map<String, dynamic>;
        final data = jsonResult['data'] as List<dynamic>;
        return data.map((item) => Posts.fromJson(item)).toList();
      } else {
        throw Exception("Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Gagal memuat data: $e");
    }
  }

  /// Load NIP dari SharedPreferences
  Future<void> _loadPreferences() async {
    final pref = await SharedPreferences.getInstance();
    final isLogin = pref.getBool("is_login") ?? false;

    if (isLogin) {
      final savedNip = pref.getString("email") ?? "";
      setState(() {
        _nip = savedNip;
        _futurePosts = _fetchPosts(_nip);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: _nip.isEmpty
            ? _buildLoadingIndicator()
            : FutureBuilder<List<Posts>>(
          future: _futurePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingIndicator();
            } else if (snapshot.hasError) {
              return _buildError(snapshot.error.toString());
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return _buildPostList(snapshot.data!);
            } else {
              return _buildEmptyState();
            }
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  /// --- Widgets kecil agar lebih clean ---

  AppBar _buildAppBar() => AppBar(
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
  );

  Widget _buildLoadingIndicator() =>
      const Center(child: CircularProgressIndicator(color: Color(0xFF3629B7)));

  Widget _buildError(String message) => Center(
    child: Text(
      'Error: $message',
      style: const TextStyle(color: Colors.red),
      textAlign: TextAlign.center,
    ),
  );

  Widget _buildEmptyState() => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.inbox, size: 64, color: Colors.grey),
        SizedBox(height: 12),
        Text(
          "Tidak ada data belanja ditemukan.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    ),
  );

  Widget _buildPostList(List<Posts> posts) => ListView.separated(
    itemCount: posts.length,
    separatorBuilder: (_, __) => const SizedBox(height: 16),
    itemBuilder: (context, index) => PostCard(posts: posts[index]),
  );

  Widget _buildBottomNavBar(BuildContext context) => BottomNavigationBar(
    backgroundColor: Colors.white,
    selectedItemColor: const Color(0xFF4DA3FF),
    unselectedItemColor: const Color(0xFF4DA3FF),
    type: BottomNavigationBarType.fixed,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Kembali"),
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Belanja"),
    ],
    onTap: (index) {
      switch (index) {
        case 0:
          Navigator.pop(context);
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const RegisterPage()),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UploadPage()),
          );
          break;
      }
    },
  );
}
