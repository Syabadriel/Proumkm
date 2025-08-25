// ignore_for_file: unused_import, prefer_const_constructors, deprecated_member_use, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_local_variable, non_constant_identifier_names

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
import 'package:proumkm/DataBelanja/Home.dart';
import 'package:proumkm/DataBelanja/posts.dart';
import 'package:proumkm/screens/form_belanja.dart';
import 'package:proumkm/screens/halaman_utama.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _rekapController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  File? _selectedFile;
  bool _isLoading = false;
  String _userEmail = "";
  final DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Mengambil data user dari shared preferences
  void _loadUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = pref.getString("email") ?? "";
    });
  }

  // Fungsi untuk menampilkan date picker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(_currentDate.year),
      lastDate: DateTime(_currentDate.year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        _tanggalController.text = DateFormat("dd-MM-yyyy").format(pickedDate);
      });
    }
  }

  // Fungsi untuk memilih file gambar
  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Fungsi untuk memvalidasi dan menyimpan data
  void _validateAndSave() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File bukti belanja harus dipilih.")),
        );
        return;
      }
      _saveData();
    }
  }

  // Fungsi untuk mengirim data ke API
  Future<void> _saveData() async {
    setState(() => _isLoading = true);

    final String rekapBelanja = _rekapController.text;
    final String jumlahUang = _jumlahController.text;
    final String tanggal = DateFormat("yyyy-MM-dd").format(
      DateFormat("dd-MM-yyyy").parse(_tanggalController.text),
    );

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://proumkm.madiunkota.go.id/api/proumkm/belanja/store'),
      );

      request.headers['passcode'] = 'k0taPendekArr';
      request.fields.addAll({
        'nip': _userEmail,
        'rekap_belanja': rekapBelanja,
        'jumlah_uang': jumlahUang,
        'tanggal': tanggal,
      });

      if (_selectedFile != null) {
        request.files.add(await http.MultipartFile.fromPath('foto1', _selectedFile!.path));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint("API Response: $responseBody");

      if (response.statusCode == 200) {
        _showSnackBar("Data berhasil diunggah!", success: true);
        _resetForm();
      } else {
        _showSnackBar("Gagal mengunggah data. Silakan coba lagi.");
      }
    } catch (e) {
      debugPrint('Error: $e');
      _showSnackBar("Terjadi kesalahan: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  void _resetForm() {
    _rekapController.clear();
    _jumlahController.clear();
    _tanggalController.clear();
    setState(() {
      _selectedFile = null;
    });
  }

  Widget _buildDatePickerField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _tanggalController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: "DD-MM-YYYY",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Tanggal harus diisi.' : null,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _pickDate(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minimumSize: Size(50, 48),
          ),
          child: Icon(Icons.calendar_today, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text("Pilih file bukti belanja", style: TextStyle(color: Colors.grey.shade700)),
          SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _selectFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: Icon(Icons.attach_file, color: Colors.white),
            label: Text("Pilih File", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 8),
          if (_selectedFile != null)
            Text(
              "File terpilih: ${_selectedFile!.path.split('/').last}",
              style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Tambah Data Belanja",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF3629B7),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildInputField(
              controller: _rekapController,
              label: "Keterangan Belanja",
              hint: "Nama Barang, Nama Toko, Nama Penjual, Lokasi",
            ),
            SizedBox(height: 16),
            _buildInputField(
              controller: _jumlahController,
              label: "Harga Barang",
              hint: "Harga Barang",
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text(
              "Tanggal Belanja",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
            ),
            SizedBox(height: 4),
            _buildDatePickerField(),
            SizedBox(height: 16),
            Text(
              "Tambahkan File Bukti",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
            ),
            SizedBox(height: 4),
            _buildFilePicker(),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _validateAndSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLoading ? Colors.blue.shade200 : Colors.blue,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 3,
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                "Simpan",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: "Kembali",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Detail Belanja",
          ),
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
              MaterialPageRoute(builder: (_) => Home()),
            );
          }
        },
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800),
        ),
        SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) => value == null || value.isEmpty ? '$label harus diisi.' : null,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}