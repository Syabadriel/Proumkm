// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:convert';
import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:proumkm/DataBelanja/Home.dart';
import 'package:proumkm/DataBelanja/posts.dart';
import 'package:proumkm/screens/form_belanja.dart';
import 'package:proumkm/screens/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = "/registerPage";

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String totalBelanja = '0';
  String totalHariIni = '0';
  String totalMingguIni = '0';
  String totalBulanIni = '0';
  String email = "";

  late Future<List<Posts>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = Future.value([]);
    _initData();
  }

  Future<void> _initData() async {
    final pref = await SharedPreferences.getInstance();
    final isLogin = pref.getBool("is_login") ?? false;

    if (isLogin) {
      setState(() {
        email = pref.getString("email") ?? "";
      });

      await _fetchData();
      setState(() {
        futurePosts = _fetchPosts();
      });
    }
  }

  Future<void> _fetchData() async {
    final response = await http.post(
      Uri.parse(
          'https://proumkm.madiunkota.go.id/api/proumkm/total/belanja/pegawai'),
      headers: {'passcode': 'k0taPendekArr'},
      body: {"nip": email},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        totalBelanja = (data['total_belanja'] ?? '0').toString();
        totalHariIni = (data['total_hari_ini'] ?? '0').toString();
        totalMingguIni = (data['total_minggu_ini'] ?? '0').toString();
        totalBulanIni = (data['total_bulan_ini'] ?? '0').toString();
      });
    }
  }

  Future<List<Posts>> _fetchPosts() async {
    final response = await http.post(
      Uri.parse(
          'https://proumkm.madiunkota.go.id/api/proumkm/belanja/pegawai'),
      headers: {"passcode": "k0taPendekArr"},
      body: {"nip": email},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResult = jsonDecode(response.body);
      return (jsonResult['data'] as List<dynamic>)
          .map((data) => Posts.fromJson(data))
          .toList();
    } else {
      throw Exception('Gagal memuat data belanja');
    }
  }

  Future<void> _logOut() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // HEADER modern
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3629B7), Color(0xFF4DA3FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Image.asset("assets/icon_login_polos.png"),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "PRO-UMKM\nKOTA MADIUN",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.3,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // BODY SCROLLABLE
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 80),
                children: [
                  // CARD UTAMA modern
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF3629B7), Color(0xFF4DA3FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_rounded,
                            color: Colors.white, size: 40),
                        SizedBox(height: 12),
                        Text("Total Belanja",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 6),
                        Text(
                          formatRupiah.format(int.tryParse(totalBelanja) ?? 0),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),

                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _menuButton(Icons.add_shopping_cart_rounded,
                                "Belanja", () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => UploadPage()));
                                }),
                            _menuButton(Icons.receipt_long_rounded,
                                "Detail Belanja", () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Home()));
                                }),
                          ],
                        ),

                        SizedBox(height: 20),

                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _infoItem("Harian",
                                  formatRupiah.format(int.tryParse(totalHariIni) ?? 0)),
                              _infoItem("Mingguan",
                                  formatRupiah.format(int.tryParse(totalMingguIni) ?? 0)),
                              _infoItem("Bulanan",
                                  formatRupiah.format(int.tryParse(totalBulanIni) ?? 0)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 28),

                  // HISTORY TITLE
                  Row(
                    children: [
                      Icon(Icons.history_rounded,
                          color: Colors.black87, size: 26),
                      SizedBox(width: 8),
                      Text("History Belanja",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildHistoryList(formatRupiah),
                ],
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION modern
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Color(0xFF3629B7),
          unselectedItemColor: Colors.grey,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.logout_rounded),
              label: "Keluar",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded),
              label: "Belanja",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              label: "Detail Belanja",
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              _logOut();
            } else if (index == 1) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => UploadPage()));
            } else if (index == 2) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Home()));
            }
          },
        ),
      ),
    );
  }

  Widget _menuButton(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Icon(icon, color: Color(0xFF3629B7), size: 28),
          ),
          SizedBox(height: 8),
          Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ],
    );
  }

  Widget _buildHistoryList(NumberFormat formatRupiah) {
    return FutureBuilder<List<Posts>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.all(24),
            child: Center(
                child: CircularProgressIndicator(color: Color(0xFF3629B7))),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.all(24),
            child: Text("Gagal memuat data.",
                style: TextStyle(color: Colors.red)),
          );
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(24),
            child: Text("Belum ada riwayat belanja.",
                style: TextStyle(color: Colors.grey[600])),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final post = items[index];
            final formattedAmount = formatRupiah
                .format(int.tryParse(post.jumlah_uang ?? '0') ?? 0);

            return AnimatedCard(
              direction: AnimatedCardDirection.left,
              duration: Duration(milliseconds: 400 + index * 100),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text('${index + 1}. ${post.nama}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(post.rekap_belanja ?? '-',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey[700])),
                  ),
                  trailing: Text(
                    formattedAmount,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700]),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
