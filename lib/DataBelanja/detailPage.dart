// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_import, unused_import, unnecessary_const, unnecessary_string_interpolations

import 'dart:ui';
import 'package:proumkm/DataBelanja/postCard.dart';
import 'package:proumkm/screens/halaman_utama.dart';
import 'package:flutter/material.dart';
import 'package:proumkm/DataBelanja/posts.dart';

class DetailPage extends StatelessWidget {
  // DetailPage({Key? key, required Posts posts}) : super(key: key);

  final Posts posts;
  const DetailPage({Key? key, required this.posts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.blueGrey[100], // Warna latar belakang yang kalem
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
        title: Text(
          'Detail Belanja',
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
      body: ListView(
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  const Color.fromARGB(255, 255, 255, 255),
                  Colors.white,
                ],
              )),
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'NIP:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          posts.nip,
                        ),

                        const Text(
                          'Nama:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          posts.nama,
                        ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        const Text(
                          'Keterangan:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          posts.rekap_belanja,
                        ),

                        const Text(
                          'Nominal:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          'Rp. ${posts.jumlah_uang}',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Foto:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Image.network(
                          '${posts.foto1}',
                          //     frameBuilder: (context, child, frame, _) {
                          //   if (frame == null) {
                          //     // fallback to placeholder
                          //     return CircularProgressIndicator();
                          //   }
                          //   return CircularProgressIndicator();
                          // }
                        ),
                        // Text('Foto: ${posts.foto1}'),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Foto:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Image.network(
                          '${posts.foto2}',
                          //     frameBuilder: (context, child, frame, _) {
                          //   if (frame == null) {
                          //     // fallback to placeholder
                          //     return CircularProgressIndicator();
                          //   }
                          //   return CircularProgressIndicator();
                          // }
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Foto:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Image.network(
                          '${posts.foto3}',
                          //     frameBuilder: (context, child, frame, _) {
                          //   if (frame == null) {
                          //     // fallback to placeholder
                          //     return CircularProgressIndicator();
                          //   }
                          //   return CircularProgressIndicator();
                          // }
                        ),
                      ])),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.pop(context);
          // Respond to button press
        },
        icon: Icon(Icons.arrow_back),
        label: Text('Kembali'),
      ),
    );
  }
}
