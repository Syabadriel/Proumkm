import 'dart:convert';
import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:proumkm/DataBelanja/Home.dart';
import 'package:proumkm/DataBelanja/posts.dart';
import 'package:proumkm/screens/form_belanja.dart';
import 'package:proumkm/screens/login_view.dart';
import 'package:proumkm/DataBelanja/detailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = "/registerPage";

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String? totalBelanja;
  String? totalHariIni;
  String? totalMingguIni;
  String? totalBulanIni;
  String email = "";

  late Future<List<Posts>> futurePosts;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final pref = await SharedPreferences.getInstance();
    final isLogin = pref.getBool("is_login") ?? false;

    if (isLogin) {
      final savedEmail = pref.getString("email") ?? "";
      if (!mounted) return;
      setState(() {
        email = savedEmail;
        futurePosts = _fetchPosts();
      });
      await _fetchData();
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
        if (!mounted) return;
        setState(() {
          totalBelanja = data['total_belanja']?.toString();
          totalHariIni = data['total_hari_ini']?.toString();
          totalMingguIni = data['total_minggu_ini']?.toString();
          totalBulanIni = data['total_bulan_ini']?.toString();
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

    // Pastikan tidak ada widget yang dibangun setelah navigasi
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  // --- REFACTOR UTAMA: PEMISAHAN WIDGET DAN PENANGANAN NULL ---

  Widget _buildSummaryCards(NumberFormat formatRupiah) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMainCard(formatRupiah),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                    "Hari Ini", totalHariIni, Icons.today, Colors.green, formatRupiah),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                    "Minggu Ini",
                    totalMingguIni,
                    Icons.calendar_view_week,
                    Colors.orange,
                    formatRupiah),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatCard(
              "Bulan Ini", totalBulanIni, Icons.calendar_month, Colors.red, formatRupiah),
        ],
      ),
    );
  }

  Widget _buildMainCard(NumberFormat formatRupiah) {
    final formattedValue = formatRupiah.format(int.tryParse(totalBelanja ?? '0') ?? 0);
    return Card(
      color: Colors.blue[900],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.account_balance_wallet, size: 48, color: Colors.white),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Belanja",
                      style: TextStyle(fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text(
                    formattedValue,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String? value, IconData icon, Color color, NumberFormat formatRupiah) {
    final formattedValue = formatRupiah.format(int.tryParse(value ?? '0') ?? 0);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    formattedValue,
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bagian build() tidak ada perubahan signifikan karena sudah cukup baik

  @override
  Widget build(BuildContext context) {
    final formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0,
        title: const Text(
          "PRO-UMKM KOTA MADIUN",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchData();
          setState(() {
            futurePosts = _fetchPosts();
          });
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildSummaryCards(formatRupiah)),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
            SliverToBoxAdapter(child: _buildHistoryTitle()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: _buildHistoryList(formatRupiah),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHistoryTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.history, color: Colors.blue[900]),
          const SizedBox(width: 10),
          const Text(
            "Riwayat Belanja",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(NumberFormat formatRupiah) {
    return FutureBuilder<List<Posts>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const SliverToBoxAdapter(
            child: Center(child: Text("Gagal memuat data")),
          );
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Belum ada riwayat belanja"),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final post = items[index];
              final formattedAmount = formatRupiah.format(
                int.tryParse(post.jumlah_uang ?? '0') ?? 0,
              );

              return AnimatedCard(
                direction: AnimatedCardDirection.left,
                duration: Duration(milliseconds: 350 + index * 100),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Icon(Icons.receipt_long, color: Colors.blue[900]),
                    ),
                    title: Text(post.nama ?? "-",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: Text(post.rekap_belanja ?? "-"),
                    trailing: Text(
                      formattedAmount,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(posts: post),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            childCount: items.length,
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UploadPage()),
        );
      },
      //belanja
      backgroundColor: Colors.blue[900],
      child: const Icon(Icons.shopping_cart, color: Colors.white),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      elevation: 6,
      color: Colors.white,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //rekap
            _buildBottomNavItem(
              icon: Icons.dashboard,
              label: "Rekapan",
              color: Colors.blue[900]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),
            //logout
            const SizedBox(width: 40),
            _buildBottomNavItem(
              icon: Icons.logout,
              label: "Logout",
              color: Colors.red,
              onTap: _logOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}