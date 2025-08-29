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

  const RegisterPage({super.key});

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
    futurePosts = Future.value([]); // initial kosong
    _initData();
  }

  Future<void> _initData() async {
    final pref = await SharedPreferences.getInstance();
    final isLogin = pref.getBool("is_login") ?? false;

    if (isLogin) {
      final savedEmail = pref.getString("email") ?? "";

      setState(() {
        email = savedEmail;
        futurePosts = _fetchPosts();
      });

      await _fetchData(); // ambil data total belanja
    }
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.post(
        Uri.parse('https://proumkm.madiunkota.go.id/api/proumkm/total/belanja/pegawai'),
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
    } catch (e) {
      debugPrint("Fetch data error: $e");
    }
  }

  Future<List<Posts>> _fetchPosts() async {
    final response = await http.post(
      Uri.parse('https://proumkm.madiunkota.go.id/api/proumkm/belanja/pegawai'),
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
      MaterialPageRoute(builder: (_) => const LoginPage()),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSummaryCard(formatRupiah),
            const SizedBox(height: 24),
            _buildHistoryTitle(),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildHistoryList(formatRupiah),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3629B7), Color(0xFF4C3FFB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset("assets/icon_login_polos.png", height: 60),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "PRO-UMKM\nKOTA MADIUN",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(NumberFormat formatRupiah) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Total Belanja",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatRupiah.format(int.tryParse(totalBelanja) ?? 0),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoCard(Icons.calendar_today, "Harian",
                  formatRupiah.format(int.tryParse(totalHariIni) ?? 0)),
              _infoCard(Icons.calendar_view_week, "Mingguan",
                  formatRupiah.format(int.tryParse(totalMingguIni) ?? 0)),
              _infoCard(Icons.calendar_month, "Bulanan",
                  formatRupiah.format(int.tryParse(totalBulanIni) ?? 0)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHistoryTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.history_rounded, color: Colors.black87, size: 26),
          SizedBox(width: 10),
          Text(
            "History Belanja",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.blue,
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
          icon: Icon(Icons.list_alt),
          label: "Detail Belanja",
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          _logOut();
        } else if (index == 1) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const UploadPage()));
        } else if (index == 2) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      },
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 13)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
      ],
    );
  }

  Widget _buildHistoryList(NumberFormat formatRupiah) {
    return FutureBuilder<List<Posts>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF3629B7)));
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Gagal memuat data.",
                style: TextStyle(color: Colors.red)),
          );
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Center(
            child: Text("Belum ada riwayat belanja.",
                style: TextStyle(color: Colors.grey[600])),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final post = items[index];
            final formattedAmount =
            formatRupiah.format(int.tryParse(post.jumlah_uang ?? '0') ?? 0);

            return AnimatedCard(
              direction: AnimatedCardDirection.left,
              duration: Duration(milliseconds: 400 + index * 100),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text('${index + 1}. ${post.nama ?? '-'}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(post.rekap_belanja ?? '-',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey[700])),
                  ),
                  trailing: Text(
                    formattedAmount,
                    style: TextStyle(
                        fontSize: 13,
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
