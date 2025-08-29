// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:proumkm/DataBelanja/posts.dart';
import 'package:proumkm/screens/form_belanja.dart';
import 'package:proumkm/screens/halaman_utama.dart';

class DetailPage extends StatelessWidget {
  final Posts posts;
  const DetailPage({super.key, required this.posts});


  void _showPhotoDialog(BuildContext context) {
    final photos = [posts.foto1, posts.foto2, posts.foto3]
        .where((foto) => foto.isNotEmpty)
        .toList();

    if (photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tidak ada foto bukti belanja."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              PageView.builder(
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      photos[index],
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade300,
                        child: Center(
                          child: Icon(Icons.broken_image,
                              size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(Icons.close_rounded, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = MediaQuery.of(context).size.width * 0.04;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5FF),
      appBar: AppBar(
        title: Text(
          "Detail Belanja",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF3629B7),
        elevation: 4,
        centerTitle: true,
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                    icon: Icons.badge,
                    label: 'NIP',
                    value: posts.nip,
                    fontSize: fontSize),
                SizedBox(height: 16),
                _buildInfoRow(
                    icon: Icons.person,
                    label: 'Nama',
                    value: posts.nama,
                    fontSize: fontSize),
                SizedBox(height: 16),
                _buildInfoRow(
                    icon: Icons.description,
                    label: 'Keterangan',
                    value: posts.rekap_belanja,
                    fontSize: fontSize),
                SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.attach_money,
                  label: 'Nominal',
                  value: "Rp. ${posts.jumlah_uang}",
                  fontSize: fontSize,
                  isNominal: true,
                ),
                SizedBox(height: 30),
                Divider(color: Colors.grey.shade300),
                SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.image_outlined,
                            size: 60, color: Color(0xFF000000)),
                        onPressed: () => _showPhotoDialog(context),
                      ),
                      Text(
                        "Lihat Foto Bukti Belanja",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Kembali"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Belanja"),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required double fontSize,
    bool isNominal = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 22),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black87)),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: fontSize,
                  color: isNominal ? Colors.green[700] : Colors.black87,
                  fontWeight:
                  isNominal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
