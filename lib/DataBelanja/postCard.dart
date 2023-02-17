// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, prefer_const_literals_to_create_immutables, unnecessary_const, prefer_const_constructors, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:aplikasi_pertama/DataBelanja/posts.dart';
import 'package:aplikasi_pertama/DataBelanja/detailPage.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key, required this.posts}) : super(key: key);
  final Posts posts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) {
                return DetailPage(posts: posts);
              }),
            ),
          );
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            width: 500,
            height: 180,
            margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
            decoration: BoxDecoration(
                color: Color.fromARGB(208, 255, 255, 255),
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(62, 19, 19, 19),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 0),
                  )
                ]),
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
              ],
            ),
          ),
          color: Color.fromARGB(127, 84, 175, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
      ),
    );
  }
}
