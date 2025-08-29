import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:proumkm/apifolders/dialogs.dart';
import 'package:proumkm/screens/halaman_utama.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nipController = TextEditingController();
  final _passwordController = TextEditingController();
  final Dialogs _dialogs = Dialogs();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  @override
  void dispose() {
    _nipController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E00B8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 60),

              /// logo
              Image.asset('assets/icon_login_putih.png', width: 120, height: 120),
              const SizedBox(height: 10),
              const Text(
                "KOTA MADIUN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "CATATAN BELANJA PEGAWAI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 30),

              /// form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Masukkan NIP dan Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 15),

                    /// nip
                    _buildNipField(),
                    const SizedBox(height: 15),

                    /// pw
                    _buildPasswordField(),
                    const SizedBox(height: 20),

                    /// tombol masuk
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4DA3FF),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _validateInputs,
                      child: const Text(
                        "MASUK",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// tombol hubungi admin
              TextButton(
                onPressed: () => _showContactAdminDialog(context),
                child: const Text(
                  'Tidak Punya akun? Hubungi Admin',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// widget nip
  Widget _buildNipField() {
    return TextFormField(
      controller: _nipController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      validator: (nip) {
        if (nip == null || nip.isEmpty) return 'NIP harus diisi';
        if (!RegExp(r'^[0-9]+$').hasMatch(nip)) return 'NIP hanya boleh berisi angka';
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Masukkan NIP',
        prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF2E00B8)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2E00B8), width: 2),
        ),
      ),
    );
  }

  /// widget pw
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (val) => val == null || val.isEmpty ? 'Password harus diisi' : null,
      decoration: InputDecoration(
        hintText: 'Masukkan Password',
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2E00B8)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2E00B8), width: 2),
        ),
      ),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      _doLogin(_nipController.text, _passwordController.text);
    }
  }

  /// Login API
  Future<void> _doLogin(String email, String password) async {
    final keyLoader = GlobalKey<State>();
    _dialogs.loading(context, keyLoader, "Proses ...");

    try {
      final response = await http.post(
        Uri.parse("https://proumkm.madiunkota.go.id/api/login"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({"email": email, "password": password}),
      );

      final output = jsonDecode(response.body);
      if (keyLoader.currentContext != null) {
        Navigator.of(keyLoader.currentContext!, rootNavigator: false).pop();
      }

      if (!mounted) return; // ✅ amanin context
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(output['message'], style: const TextStyle(fontSize: 16))),
        );
        if (output['success'] == true) {
          await _saveSession(email);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(output.toString(), style: const TextStyle(fontSize: 16))),
        );
      }
    } catch (e) {
      if (keyLoader.currentContext != null) {
        Navigator.of(keyLoader.currentContext!, rootNavigator: false).pop();
      }
      if (!mounted) return;
      Dialogs.popUp(context, '$e');
    }
  }

  /// Simpan ke SharedPreferences
  Future<void> _saveSession(String email) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("email", email);
    await pref.setBool("is_login", true);

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
          (route) => false,
    );
  }

  Future<void> _checkLogin() async {
    final pref = await SharedPreferences.getInstance();
    final isLogin = pref.getBool("is_login") ?? false;
    if (isLogin) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RegisterPage()),
            (route) => false,
      );
    }
  }

  /// dialog admin
  void _showContactAdminDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.contact_mail, color: Colors.blue),
              SizedBox(width: 10),
              Text('Kontak Admin Kota', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Untuk mendapatkan NIP dan Password, silakan hubungi admin kota melalui email di bawah:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  onTap: _launchEmailApp,
                  child: const Text(
                    'kominfo@madiunkota.go.id',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(child: Icon(Icons.email_outlined, color: Colors.blue, size: 40)),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchEmailApp() async {
    const email = 'mailto:kominfo@madiunkota.go.id';
    final Uri emailUri = Uri.parse(email);

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $email';
    }
  }
}
