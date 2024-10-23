// ignore_for_file: unused_import, prefer_const_constructors, deprecated_member_use, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_local_variable, non_constant_identifier_names, duplicate_ignore

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:proumkm/DataBelanja/posts.dart';
import 'package:proumkm/screens/halaman_utama.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String txtRekap = "";
  String txtJumlah = "";
  // String txtToko = "";
  String txtTgl = "";

  bool isFilePicker1Selected = false;
  bool isFilePicker2Selected = false;
  bool isFilePicker3Selected = false;
  bool isLoading = false;

  // var txtEditToko = TextEditingController();
  var txtEditJumlah = TextEditingController();
  var txtEditRekap = TextEditingController();
  var txtDate = TextEditingController();
  var txtFilePicker1 = TextEditingController();
  var txtFilePicker2 = TextEditingController();
  var txtFilePicker3 = TextEditingController();
  DateTime date = DateTime.now();

  File? filePickerVal1;
  File? filePickerVal2;
  File? filePickerVal3;

  Widget buildDatePicker(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
                readOnly: true,
                controller: txtDate,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal harus diisi';
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  hintText: 'Tanggal File',
                  contentPadding: EdgeInsets.all(10.0),
                ),
                style: const TextStyle(fontSize: 16.0)),
          ),
          const SizedBox(width: 5),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 0, 228, 224),
                minimumSize: const Size(70, 48),
                maximumSize: const Size(70, 48)),
            onPressed: () => pickDatePicker(context),
            child: const FaIcon(
              FontAwesomeIcons.calendarDay,
              color: Colors.white,
              size: 24.0,
            ),
          ),
        ],
      ),
    );
  }

  Future pickDatePicker(BuildContext context) async {
    final newDatePicker = await showDatePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDate: date,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 400.0, maxHeight: 520.0),
                  child: child,
                ),
              )
            ],
          );
        });

    if (newDatePicker == null) return;

    setState(() {
      //
      String rawDate = newDatePicker.toString();
      var explode = rawDate.split(" ");
      String waktu = convertDateFromString(explode[0]).toString();
      txtDate.text = waktu;
    });
  }

  Widget buildFilePicker() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          TextFormField(
            readOnly: true,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'File harus diupload';
              } else {
                return null;
              }
            },
            controller: txtFilePicker1,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              hintText: 'Upload File 1',
              contentPadding: EdgeInsets.all(10.0),
            ),
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(width: 5),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.upload_file,
              color: Colors.white,
              size: 24.0,
            ),
            label: const Text('Pilih File', style: TextStyle(fontSize: 16.0)),
            onPressed: () {
              selectFile1();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 0, 228, 224),
              minimumSize: const Size(122, 48),
              maximumSize: const Size(122, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          TextFormField(
            readOnly: true,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'File harus diupload';
              } else {
                return null;
              }
            },
            controller: txtFilePicker2,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              hintText: 'Upload File 2',
              contentPadding: EdgeInsets.all(10.0),
            ),
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(width: 5),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.upload_file,
              color: Colors.white,
              size: 24.0,
            ),
            label: const Text('Pilih File', style: TextStyle(fontSize: 16.0)),
            onPressed: () {
              selectFile2();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 0, 228, 224),
              minimumSize: const Size(122, 48),
              maximumSize: const Size(122, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
          TextFormField(
            readOnly: true,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'File harus diupload';
              } else {
                return null;
              }
            },
            controller: txtFilePicker3,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              hintText: 'Upload File 3',
              contentPadding: EdgeInsets.all(10.0),
            ),
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(width: 5),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.upload_file,
              color: Colors.white,
              size: 24.0,
            ),
            label: const Text('Pilih File', style: TextStyle(fontSize: 16.0)),
            onPressed: () {
              selectFile3();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 0, 228, 224),
              minimumSize: const Size(122, 48),
              maximumSize: const Size(122, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  selectFile1() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Media'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Kamera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    pickImageFromCamera(1);
                  },
                ),
                SizedBox(height: 35),
                GestureDetector(
                  child: Text('Galeri'),
                  onTap: () {
                    Navigator.of(context).pop();
                    pickImageFromGallery(1);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  selectFile2() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Media'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Kamera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    pickImageFromCamera(2);
                  },
                ),
                SizedBox(height: 35),
                GestureDetector(
                  child: Text('Galeri'),
                  onTap: () {
                    Navigator.of(context).pop();
                    pickImageFromGallery(2);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  selectFile3() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Media'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Kamera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    pickImageFromCamera(3);
                  },
                ),
                SizedBox(height: 35),
                GestureDetector(
                  child: Text('Galeri'),
                  onTap: () {
                    Navigator.of(context).pop();
                    pickImageFromGallery(3);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLoadingDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Tidak bisa menutup popup dengan mengklik area luar
      builder: (BuildContext context) {
        return WillPopScope(
          // Mencegah pengguna menutup popup dengan mengklik tombol back
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('Mengupload data...'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  pickImageFromCamera(int fileNumber) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() async {
        // Mengompres gambar sebelum menyetel nilai filePickerVal
        var compressedImage = await FlutterImageCompress.compressWithFile(
          pickedFile.path,
          minWidth: 800,
          minHeight: 600,
          quality: 60,
        );

        // Tampilkan detail ukuran dan kualitas gambar yang terkompres
        print(
            'File $fileNumber compressed. Original Size: ${File(pickedFile.path).lengthSync()} bytes, Compressed Size: ${compressedImage!.length} bytes, Quality: 60');

        if (fileNumber == 1) {
          txtFilePicker1.text = pickedFile.path;
          filePickerVal1 = File(pickedFile.path);
        } else if (fileNumber == 2) {
          txtFilePicker2.text = pickedFile.path;
          filePickerVal2 = File(pickedFile.path);
        } else if (fileNumber == 3) {
          txtFilePicker3.text = pickedFile.path;
          filePickerVal3 = File(pickedFile.path);
        }
      });
    }
  }

  pickImageFromGallery(int fileNumber) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg'],
    );

    if (result != null) {
      setState(() async {
        // Mengompres gambar sebelum menyetel nilai filePickerVal
        var compressedImage = await FlutterImageCompress.compressWithFile(
          result.files.single.path!,
          minWidth: 800,
          minHeight: 600,
          quality: 50,
        );

        // Tampilkan detail ukuran dan kualitas gambar yang terkompres
        print(
            'File $fileNumber compressed. Original Size: ${File(result.files.single.path!).lengthSync()} bytes, Compressed Size: ${compressedImage!.length} bytes, Quality: 60');

        if (fileNumber == 1) {
          txtFilePicker1.text = result.files.single.name;
          filePickerVal1 = File(result.files.single.path!);
        } else if (fileNumber == 2) {
          txtFilePicker2.text = result.files.single.name;
          filePickerVal2 = File(result.files.single.path!);
        } else if (fileNumber == 3) {
          txtFilePicker3.text = result.files.single.name;
          filePickerVal3 = File(result.files.single.path!);
        }
      });
    }
  }

  // Panggil fungsi mengompres gambar sebelum memanggil simpan()
  _validateInputs() {
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState!.save();
      // Memanggil fungsi mengompres gambar sebelum memanggil simpan()
      compressImagesAndSave();
    }
  }

// Fungsi untuk mengompres gambar dan menyimpan
  compressImagesAndSave() {
    // Mengompres gambar sebelum memanggil simpan()
    // Pastikan gambar sudah terkompres sebelum memanggil simpan()
    simpan();
  }

  String email = "";
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      setState(() {
        email = pref.getString("email")!;
      });
    }
  }

  simpan() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("nip", email);

    // ignore: non_constant_identifier_names
    final String rekap_belanja = txtEditRekap.text; //txtNama;
    final String jumlah_uang = txtEditJumlah.text;
    var rawTgl = txtDate.text.split("-");
    var yM = rawTgl[0];
    var mM = rawTgl[1];
    var dM = rawTgl[2];
    final String waktu = yM + "-" + mM + "-" + dM;
    // final String updated_at = yM + "-" + mM + "-" + dM;
    // final String created_at = yM + "-" + mM + "-" + dM;

    try {
      _showLoadingDialog();
      // setState(() {
      //   isLoading = true; // Set isLoading ke true saat proses dimulai
      // });
      //post date
      Map<String, String> headers = {
        "passcode": "k0taPendekArr",
      };
      Map<String, String> body = {
        "nip": email,
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://proumkm.madiunkota.go.id/api/proumkm/belanja/store'));

      request.headers.addAll(headers);
      request.fields['nip'] = email;
      request.fields['rekap_belanja'] = rekap_belanja;
      request.fields['jumlah_uang'] = jumlah_uang;
      request.fields['tanggal'] = waktu;

      request.files.add(http.MultipartFile(
          'foto1',
          filePickerVal1!.readAsBytes().asStream(),
          filePickerVal1!.lengthSync(),
          filename: filePickerVal1!.path.split("/").last));

      request.files.add(http.MultipartFile(
          'foto2',
          filePickerVal2!.readAsBytes().asStream(),
          filePickerVal2!.lengthSync(),
          filename: filePickerVal2!.path.split("/").last));

      request.files.add(http.MultipartFile(
          'foto3',
          filePickerVal3!.readAsBytes().asStream(),
          filePickerVal3!.lengthSync(),
          filename: filePickerVal3!.path.split("/").last));

      var res = await request.send();
      var responseBytes = await res.stream.toBytes();
      var responseString = utf8.decode(responseBytes);

      //debug
      debugPrint("response code: " + res.statusCode.toString());
      debugPrint("response: " + responseString.toString());
      var encodeFirst = json.encode(responseString);

      var dataDecode = json.decode(encodeFirst);
      debugPrint(dataDecode.toString());

      if (res.statusCode == 200) {
        _hideLoadingDialog();
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Informasi'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text("File berhasil diupload"),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    //
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                ),
              ],
            );
          },
        );
      } else {
        _hideLoadingDialog();
      }
    } catch (e) {
      _hideLoadingDialog();
      debugPrint('$e');
    } finally {
      setState(() {
        isLoading =
            false; // Set isLoading ke false setelah proses selesai, baik sukses atau gagal
      });
    }
  }

  convertDateFromString(String strDate) {
    DateTime date = DateTime.parse(strDate);
    return DateFormat("yyyy-MM-dd").format(date);
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.blueGrey[100], // Warna latar belakang yang kalem
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
        title: Text(
          'Tambah Data Belanja',
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
        actions: [],
      ),

// FORM NAMA BARANG
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Colors.white,
            ],
          )),
          child: ListView(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text("Keterangan Belanja",
                    style: TextStyle(fontSize: 16.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    key: Key(txtRekap),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama barang harus diisi';
                      } else {
                        return null;
                      }
                    },
                    controller: txtEditRekap,
                    onSaved: (String? val) {
                      txtEditRekap.text = val!;
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2)),
                      hintText:
                          "Nama belanja'an, Nama toko, Nama Penjual, Lokasi Belanja",
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    style: const TextStyle(fontSize: 16.0)),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text("Harga Barang", style: TextStyle(fontSize: 16.0)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    key: Key(txtJumlah),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga barang harus diisi';
                      } else {
                        return null;
                      }
                    },
                    controller: txtEditJumlah,
                    onSaved: (String? val) {
                      txtEditJumlah.text = val!;
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2)),
                      hintText: 'Harga barang',
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    style: const TextStyle(fontSize: 16.0)),
              ),
// FORM NAMA BARANG SAMPE SINI
              const Padding(
                padding: EdgeInsets.all(5.0),
                child:
                    Text("Tanggal belanja", style: TextStyle(fontSize: 16.0)),
              ),

              buildDatePicker(context),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Browse File", style: TextStyle(fontSize: 16.0)),
              ),
              buildFilePicker(),
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 32.0,
                  ),
                  label: const Text('SIMPAN', style: TextStyle(fontSize: 18.0)),
                  onPressed: isLoading
                      ? null
                      : () {
                          setState(() {
                            isLoading = true;
                          });
                          _validateInputs();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 228, 224),
                    minimumSize: const Size(115, 55),
                    maximumSize: const Size(115, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                    size: 32.0,
                  ),
                  label:
                      const Text('Kembali', style: TextStyle(fontSize: 18.0)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 181, 21),
                    minimumSize: const Size(115, 55),
                    maximumSize: const Size(115, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
