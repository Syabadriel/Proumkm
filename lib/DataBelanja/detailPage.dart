// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_import, unused_import, unnecessary_const, unnecessary_string_interpolations

import 'dart:ui';
import 'package:aplikasi_pertama/DataBelanja/postCard.dart';
import 'package:aplikasi_pertama/screens/halaman_utama.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_pertama/DataBelanja/posts.dart';

class DetailPage extends StatelessWidget {
  // DetailPage({Key? key, required Posts posts}) : super(key: key);

  final Posts posts;
  const DetailPage({Key? key, required this.posts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          (Icons.date_range_outlined),
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
          ("DETAIL BELANJA"),
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
                  Colors.cyan.shade300,
                  Colors.white,
                ],
              )),
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
        backgroundColor: const Color(0xff03dac6),
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
