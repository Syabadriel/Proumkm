import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:proumkm/DataBelanja/Home.dart';
import 'package:proumkm/screens/halaman_utama.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});


  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _rekapController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _tanggalController = TextEditingController();

  File? _selectedFile;
  bool _isLoading = false;
  String _userEmail = "";
  final DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _rekapController.dispose();
    _jumlahController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  /// Ambil data user dari SharedPreferences
  Future<void> _loadUserData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => _userEmail = pref.getString("email") ?? "");
  }

  /// Date Picker
  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(_currentDate.year),
      lastDate: DateTime(_currentDate.year + 5),
    );
    if (pickedDate != null) {
      _tanggalController.text = DateFormat("dd-MM-yyyy").format(pickedDate);
    }
  }

  /// File Picker
  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result != null) {
      setState(() => _selectedFile = File(result.files.single.path!));
    }
  }

  /// Validasi sebelum simpan
  void _validateAndSave() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedFile == null) {
      _showSnackBar("File bukti belanja harus dipilih.");
      return;
    }
    _saveData();
  }

  /// Simpan data ke API
  Future<void> _saveData() async {
    setState(() => _isLoading = true);

    try {
      final tanggal = DateFormat("yyyy-MM-dd").format(
        DateFormat("dd-MM-yyyy").parse(_tanggalController.text),
      );

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://proumkm.madiunkota.go.id/api/proumkm/belanja/store'),
      )
        ..headers['passcode'] = 'k0taPendekArr'
        ..fields.addAll({
          'nip': _userEmail,
          'rekap_belanja': _rekapController.text,
          'jumlah_uang': _jumlahController.text,
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
    setState(() => _selectedFile = null);
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Tanggal harus diisi.' : null,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _pickDate(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minimumSize: const Size(50, 48),
          ),
          child: const Icon(Icons.calendar_today, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text("Pilih file bukti belanja", style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _selectFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.attach_file, color: Colors.white),
            label: const Text("Pilih File", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 8),
          if (_selectedFile != null)
            Text(
              "File terpilih: ${_selectedFile!.path.split('/').last}",
              style: const TextStyle(color: Colors.black54, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
        ],
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
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) => value == null || value.isEmpty ? '$label harus diisi.' : null,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Tambah Data Belanja",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3629B7),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3629B7)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildInputField(
              controller: _rekapController,
              label: "Keterangan Belanja",
              hint: "Nama Barang, Nama Toko, Nama Penjual, Lokasi",
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _jumlahController,
              label: "Harga Barang",
              hint: "Harga Barang",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Text("Tanggal Belanja",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
            const SizedBox(height: 4),
            _buildDatePickerField(),
            const SizedBox(height: 16),
            Text("Tambahkan File Bukti",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
            const SizedBox(height: 4),
            _buildFilePicker(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _validateAndSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLoading ? Colors.blue.shade200 : Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 3,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
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
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Kembali"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Detail Belanja"),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RegisterPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
          }
        },
      ),
    );
  }
}
