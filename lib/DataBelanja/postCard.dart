// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, prefer_const_literals_to_create_immutables, unnecessary_const, prefer_const_constructors, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:proumkm/DataBelanja/posts.dart';
import 'package:proumkm/DataBelanja/detailPage.dart';

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
              color: Colors.grey[200], // Warna latar belakang yang kalem
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'NIP:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              16, // Ukuran teks yang proporsional untuk orang tua
                        ),
                      ),
                      Text(
                        posts.nip,
                        style: TextStyle(
                          fontSize:
                              16, // Ukuran teks yang proporsional untuk orang tua
                        ),
                      ),
                      Text(
                        'Nama:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              16, // Ukuran teks yang proporsional untuk orang tua
                        ),
                      ),
                      Text(
                        posts.nama,
                        style: TextStyle(
                          fontSize:
                              16, // Ukuran teks yang proporsional untuk orang tua
                        ),
                      ),
                      Text(
                        'Keterangan:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              16, // Ukuran teks yang proporsional untuk orang tua
                        ),
                      ),
                      Text(
                        posts.rekap_belanja,
                        style: TextStyle(
                          fontSize:
                              16, // Ukuran teks yang proporsional untuk orang tua
                        ),
                      ),
                      Text(
                        'Nominal:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              16, // Ukuran teks yang proporsional untuk orang tua
                        ),
                      ),
                      Text(
                        'Rp. ${posts.jumlah_uang}',
                        style: TextStyle(
                          fontSize:
                              16, // Ukuran teks yang proporsional untuk orang tua
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      "${posts.foto1}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
