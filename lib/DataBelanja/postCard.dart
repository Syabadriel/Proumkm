// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:proumkm/DataBelanja/detailPage.dart';
import 'package:proumkm/DataBelanja/posts.dart';

class PostCard extends StatelessWidget {
  final Posts posts;
  const PostCard({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(posts: posts),
            ),
          );
        },
        child: Card(
          elevation: 6,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: posts.foto1.isNotEmpty
                    ? Image.network(
                  posts.foto1,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildNoImage(),
                )
                    : _buildNoImage(),
              ),

              // Konten teks
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NIP & Nama
                    Text(
                      "NIP: ${posts.nip}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      posts.nama,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Rekap Belanja
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.description, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            posts.rekap_belanja,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Nominal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.monetization_on,
                                size: 20, color: Colors.green[700]),
                            const SizedBox(width: 6),
                            Text(
                              "Nominal",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Rp. ${posts.jumlah_uang}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoImage() {
    return Image.asset(
      "assets/noimage.png",
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
