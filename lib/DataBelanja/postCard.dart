// ignore_for_file: file_names, duplicate_ignore, prefer_const_literals_to_create_immutables, unnecessary_const, prefer_const_constructors, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:proumkm/DataBelanja/detailPage.dart';
import 'package:proumkm/DataBelanja/posts.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key, required this.posts}) : super(key: key);
  final Posts posts;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
            margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
            decoration: BoxDecoration(
              color: Colors.grey[200], 
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
                    mainAxisSize: MainAxisSize.min, // Tinggi sesuai konten
                    children: [
                      Text(
                        'NIP:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        posts.nip,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Nama:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        posts.nama,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Keterangan:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          posts.rekap_belanja,
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      Text(
                        'Nominal:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Rp. ${posts.jumlah_uang}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
  width: 120,
  height: 120,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(10.0),
    child: posts.foto1 != null && posts.foto1.isNotEmpty
        ? Image.network(
            posts.foto1,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/noimage.png', // Gambar placeholder
                fit: BoxFit.cover,
              );
            },
          )
        : Image.asset(
            'assets/noimage.png', // Gambar default jika URL null
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
