// ignore_for_file: non_constant_identifier_names
import 'dart:core';

class Posts {
  // int id;
  String nip;
  String rekap_belanja;
  String jumlah_uang;
  String foto1;
  String foto2;
  String foto3;
  String nama;
  // String waktu;
  // String createdAt;
  // String updatedAt;
  // String total_belanja;
  // String total_tahun_ini;
  // String total_bulan_ini;
  // String total_minggu_ini;
  // String total_hari_ini;
  // String namaOpd;
  // String opdId;
  // String kodeOpdSipd;

  Posts({
    // required this.id,
    required this.nip,
    required this.rekap_belanja,
    required this.jumlah_uang,
    required this.foto1,
    required this.foto2,
    required this.foto3,
    required this.nama,
    // required this.total_belanja,
    // required this.total_tahun_ini,
    // required this.total_bulan_ini,
    // required this.total_minggu_ini,
    // required this.total_hari_ini,
    // required this.waktu,
    // required this.createdAt,
    // required this.updatedAt,

    // required this.namaOpd,
    // required this.opdId,
    // required this.kodeOpdSipd
  });

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        nip: json['nip'],
        nama: json['nama'],
        rekap_belanja: json['rekap_belanja'],
        jumlah_uang: json['jumlah_uang'],
        foto1: json['foto1'],
        foto2: json['foto2'],
        foto3: json['foto3'],
        // total_belanja: json['total_belanja'],
        // total_bulan_ini: json['total_tahun_ini'],
        // total_hari_ini: json['total_bulan_ini'],
        // total_minggu_ini: json['total_minggu_ini'],
        // total_tahun_ini: json['total_hari_ini'],
      );
}

// ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));

// String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

// class ResponseModel {
//     ResponseModel({
//         required this.id,
//     });

//     int id;

//     ResponseModel copyWith({
//         required int id,
//     }) =>
//         ResponseModel(
//             id: id ?? this.id,
//         );

//     factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
//         id: json["id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//     };
// }

// Future<ResponseModel> apiCall() async{
// late ResponseModel model;
// Map<String, String> body = {};

// final response = await
// http.post("https://jsonplaceholder.typicode.com/posts" as Uri, body: body);

// //// 201 status is post created status
// /// 200 status is ok status
// if (response.statusCode == 201) {
//   ///Convert json to ResponseModel class
//   model = ResponseModel.fromJson(response.body as Map<String, dynamic>);
//   return model;
// }
//  throw Error();
// }

// FutureBuilder(
// future: apiCall(), // async api call work
// builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//    switch (snapshot.connectionState) {
//      case ConnectionState.waiting: return Text('Loading....');
//      default:
//        if (snapshot.hasError){
//           return Text('Error: ${snapshot.error}');
//        }
//        else{
//       ///Here fetch api response
//       ResponseModel response = snapshot.data;

//       /// print id on terminal
//       debugPrint("ID ${response.id}");

//       /// Use it in text
//       return Text('Result: ${response.id}');
//       }
//     }
//   },
//  );

//CLASS TOTAL
// class Total {
//   String total_belanja;
//   String total_tahun_ini;
//   String total_bulan_ini;
//   String total_minggu_ini;
//   String total_hari_ini;

//   Total({
//     required this.total_belanja,
//     required this.total_tahun_ini,
//     required this.total_bulan_ini,
//     required this.total_minggu_ini,
//     required this.total_hari_ini,
//   });

//   factory Total.fromJson(Map<String, dynamic> json) => Total(
//         total_belanja: json['total_belanja'],
//         total_bulan_ini: json['total_tahun_ini'],
//         total_hari_ini: json['total_bulan_ini'],
//         total_minggu_ini: json['total_minggu_ini'],
//         total_tahun_ini: json['total_hari_ini'],
//       );
// }

// class totalbelanja extends StatefulWidget {
//   static const routeName = "/registerPage";

//   final total totall;
//   //  final _formKey = GlobalKey<FormState>();
//   // const totalbelanja({Key? key}) : super(key: key);
//   const totalbelanja({Key? key, required this.totall}) : super(key: key);
//   @override
//   State<totalbelanja> createState() => _totalbelanjaState();
// }

// class _totalbelanjaState extends State<totalbelanja> {
//   final _formKey = GlobalKey<FormState>();

//   Future<List<total?>> fetchtotal() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.setString("nip", email);
//     var response = await http.post(
//       Uri.parse(
//           'https://proumkm.madiunkota.go.id/api/proumkm/total/belanja/pegawai'),

//       headers: {
//         "passcode": "k0taPendekArr",
//       },
//       // body: {
//       //   "nip": "197712172011011004",
//       // }
//       body: {
//         "nip": email,
//       },
//     );

//     print(response.statusCode);
//     print(response.body);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResult = jsonDecode(response.body);

//       List<total> totall = (jsonResult as List<dynamic>)
//           .map((data) => total.fromJson(data))
//           .toList();
//       return totall;
//     } else {
//       throw Exception('Failed to load Posts');
//     }
//   }

//   String email = "";
//   getPref() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var islogin = pref.getBool("is_login");
//     if (islogin != null && islogin == true) {
//       setState(() {
//         email = pref.getString("email")!;
//       });
//     }
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   final total totall;
//   //   return RegisterPage();
//   // }
// }

// class Api {
//   String email;

//   Api({
//     required this.email,
//   });

//   factory Api.fromJson(Map<String, dynamic> json) => Api(
//         email: json['nip'],
//       );
// }
