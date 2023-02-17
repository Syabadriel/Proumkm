// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_const_constructors, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_pertama/screens/halaman_utama.dart';

import 'package:aplikasi_pertama/apifolders/dialogs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPage();
}

class HeadClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _LoginPage extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var txtEditEmail = TextEditingController();
  var txtEditPwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.white,
            ],
          )),
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    _iconLogin(),
                    _titleDescription(),

                    const SizedBox(height: 10.0),

                    inputEmail(),
                    const SizedBox(height: 20.0),
                    inputPassword(),
                    const SizedBox(height: 5.0),
                    _buildButton(context),
                    // _textField(context),
                    // headerSection(),
                    // textSection(),
                    // buttonSection(),
                    // // _Checkbox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconLogin() {
    return Image.asset(
      'assets/icon_login.png',
      width: 150.0,
      height: 150.0,
    );
  }

  Widget _titleDescription() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
        ),
        Text(
          "CATATAN BELANJA PEGAWAI",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 107, 28, 204),
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.0),
        ),
        Text(
          "Masukkan NIP dan Password",
          style: TextStyle(
            color: Color.fromARGB(255, 11, 11, 11),
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget inputEmail() {
    return TextFormField(
        cursorColor: Color.fromARGB(255, 0, 0, 0),
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        validator: (email) => email != null &&
                !EmailValidator.validate(email) &&
                RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{30,}$')
                    .hasMatch(email)
            ? 'Masukkan email yang valid'
            : null,
        controller: txtEditEmail,
        onSaved: (String? val) {
          txtEditEmail.text = val!;
        },
        decoration: InputDecoration(
          hintText: 'Masukkan NIP',
          hintStyle: const TextStyle(color: Color.fromARGB(255, 139, 135, 135)),
          labelText: "Masukkan NIP",
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 139, 135, 135)),
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: Color.fromARGB(255, 107, 28, 204),
          ),
          fillColor: Color.fromARGB(255, 10, 255, 10),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 107, 28, 204),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 107, 28, 204),
              width: 2.0,
            ),
          ),
        ),
        style: const TextStyle(
            fontSize: 16.0, color: Color.fromARGB(255, 0, 0, 0)));
  }

  Widget inputPassword() {
    return TextFormField(
      cursorColor: Color.fromARGB(255, 0, 0, 0),
      keyboardType: TextInputType.text,
      autofocus: false,
      obscureText: true, //make decript inputan
      validator: (String? arg) {
        if (arg == null || arg.isEmpty) {
          return 'Password harus diisi';
        } else {
          return null;
        }
      },
      controller: txtEditPwd,
      onSaved: (String? val) {
        txtEditPwd.text = val!;
      },
      decoration: InputDecoration(
        hintText: 'Masukkan Password',
        hintStyle: const TextStyle(color: Color.fromARGB(255, 139, 135, 135)),
        labelText: "Masukkan Password",
        labelStyle: const TextStyle(color: Color.fromARGB(255, 139, 135, 135)),
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: Color.fromARGB(255, 107, 28, 204),
        ),
        fillColor: Color.fromARGB(255, 10, 255, 10),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 107, 28, 204),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 107, 28, 204),
            width: 2.0,
          ),
        ),
      ),
      style:
          const TextStyle(fontSize: 16.0, color: Color.fromARGB(255, 0, 0, 0)),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      //If all data are correct then save data to out variables
      _formKey.currentState!.save();
      doLogin(txtEditEmail.text, txtEditPwd.text);
    }
  }

  doLogin(email, password) async {
    final GlobalKey<State> _keyLoader = GlobalKey<State>();
    Dialogs.loading(context, _keyLoader, "Proses ...");

    try {
      final response = await http.post(
          Uri.parse("https://proumkm.madiunkota.go.id/api/login"),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode({
            "email": email,
            "password": password,
          }));

      final output = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            output['message'],
            style: const TextStyle(fontSize: 16),
          )),
        );

        if (output['success'] == true) {
          saveSession(email);
        }
        //debugPrint(output['message']);
      } else {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
        //debugPrint(output['message']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            output.toString(),
            style: const TextStyle(fontSize: 16),
          )),
        );
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
      Dialogs.popUp(context, '$e');
      debugPrint('$e');
    }
  }

  saveSession(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("email", email);
    await pref.setBool("is_login", true);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => RegisterPage(),
      ),
      (route) => false,
    );
  }

  void ceckLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RegisterPage(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    ceckLogin();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 107, 28, 204),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(color: Colors.blue),
          ),
          elevation: 10,
        ),
        onPressed: () => _validateInputs(),
        icon: const Icon(Icons.arrow_right_alt),
        label: const Text(
          "MASUK",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Widget _textField(BuildContext context) {
  //   final _formKey = GlobalKey<FormState>();
  //   var txtEditEmail = TextEditingController();
  //   var txtEditPwd = TextEditingController();
  //   bool isEmail(String email) => EmailValidator.validate(email);
  //   bool isPhone(String email) =>
  //       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{30,}$')
  //           .hasMatch(email);
  //   return Form(
  //     key: _formKey,
  //     child: Column(
  //       children: <Widget>[
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: TextFormField(
  //             keyboardType: TextInputType.phone,
  //             decoration: new InputDecoration(
  //               hintText: "Masukkan NIP",
  //               labelText: "NIP",
  //               icon: Icon(Icons.people),
  //               border: OutlineInputBorder(
  //                   borderRadius: new BorderRadius.circular(5.0)),
  //             ),
  //             validator: (value) {
  //               if (isEmail(value!) && isPhone(value)) {
  //                 return 'Mohon Masukkan NIP yang benar';
  //               }
  //               return null;
  //             },
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(top: 12.0),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: TextFormField(
  //             obscureText: true,
  //             decoration: new InputDecoration(
  //               labelText: "Password",
  //               icon: Icon(Icons.security),
  //               border: OutlineInputBorder(
  //                   borderRadius: new BorderRadius.circular(5.0)),
  //             ),
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Password tidak boleh kosong';
  //               }
  //               return null;
  //             },
  //             controller: txtEditPwd,
  //             onSaved: (String? val) {
  //               txtEditPwd.text = val!;
  //             },
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(top: 16.0),
  //         ),
  //         ElevatedButton.icon(
  //           label: Text(
  //             'MASUK',
  //             style: TextStyle(
  //               color: Color.fromARGB(255, 255, 255, 255),
  //               fontSize: 18.0,
  //             ),
  //           ),
  //           icon: Icon(Icons.login),
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Color.fromARGB(255, 107, 28, 204),
  //           ),
  //           onPressed: () {
  //             if (_formKey.currentState!.validate()) {
  //               Navigator.pushNamed(context, RegisterPage.routeName);
  //               // If the form is valid, display a snackbar. In the real world,
  //               // you'd often call a server or save the information in a database.
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(content: Text('Memproses Data . . .')),
  //               );
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
//  Widget inputEmail() {
//     return TextFormField(
//         cursorColor: Color.fromARGB(255, 14, 14, 14),
//         keyboardType: TextInputType.emailAddress,
//         autofocus: false,
//         validator: (email) => email != null && !EmailValidator.validate(email)
//             ? 'Masukkan email yang valid'
//             : null,
//         controller: txtEditEmail,
//         onSaved: (String? val) {
//           txtEditEmail.text = val!;
//         },
//         decoration: InputDecoration(
//           hintText: 'Masukkan Email',
//           hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
//           labelText: "Masukkan Email",
//           labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
//           prefixIcon: const Icon(
//             Icons.email_outlined,
//             color: Color.fromARGB(255, 37, 191, 247),
//           ),
//           fillColor: Color.fromARGB(255, 0, 0, 0),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25.0),
//             borderSide: const BorderSide(
//               color: Color.fromARGB(255, 37, 191, 247),
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25.0),
//             borderSide: const BorderSide(
//               color: Color.fromARGB(255, 37, 191, 247),
//               width: 2.0,
//             ),
//           ),
//         ),
//         style: const TextStyle(
//             fontSize: 16.0, color: Color.fromARGB(255, 0, 0, 0)));
//   }
//   Widget inputPassword() {
//     return TextFormField(
//       cursorColor: Color.fromARGB(255, 0, 0, 0),
//       keyboardType: TextInputType.text,
//       autofocus: false,
//       obscureText: true, //make decript inputan
//       validator: (String? arg) {
//         if (arg == null || arg.isEmpty) {
//           return 'Password harus diisi';
//         } else {
//           return null;
//         }
//       },
//       controller: txtEditPwd,
//       onSaved: (String? val) {
//         txtEditPwd.text = val!;
//       },
//       decoration: InputDecoration(
//         hintText: 'Masukkan Password',
//         hintStyle: const TextStyle(color: Colors.white),
//         labelText: "Masukkan Password",
//         labelStyle: const TextStyle(color: Colors.white),
//         prefixIcon: const Icon(
//           Icons.lock_outline,
//           color: Color.fromARGB(255, 37, 191, 247),
//         ),
//         fillColor: Colors.white,
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(25.0),
//           borderSide: const BorderSide(
//             color: Color.fromARGB(255, 37, 191, 247),
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(25.0),
//           borderSide: const BorderSide(
//             color: Color.fromARGB(255, 37, 191, 247),
//             width: 2.0,
//           ),
//         ),
//       ),
//       style:
//           const TextStyle(fontSize: 16.0, color: Color.fromARGB(255, 0, 0, 0)),
//     );
//   }

//   void _validateInputs() {
//     if (_formKey.currentState!.validate()) {
//       //If all data are correct then save data to out variables
//       _formKey.currentState!.save();
//       doLogin(txtEditEmail.text, txtEditPwd.text);
//     }
//   }

//   doLogin(email, password) async {
//     final GlobalKey<State> _keyLoader = GlobalKey<State>();
//     final prefs = await SharedPreferences.getInstance();
//     // Dialogs.loading(context, _keyLoader, "Proses ...");

//     try {
//       final response = await http.post(
//           Uri.parse("https://proumkm.madiunkota.go.id/api/login"),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({
//             "email": "$email",
//             "password": "$password",
//           }));

//       final output = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//             output['message'],
//             style: const TextStyle(fontSize: 16),
//           )),
//         );

//         if (output['success'] == true) {
//           saveSession("$email");
//         }
//         //debugPrint(output['message']);
//       } else {
//         Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();
//         //debugPrint(output['message']);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//             output.toString(),
//             style: const TextStyle(fontSize: 16),
//           )),
//         );
//       }
//     } catch (e) {
//       Navigator.of(_keyLoader.currentContext!, rootNavigator: false).pop();

//       // Dialogs.popUp(context, '$e');
//       debugPrint('$e');
//     }
//   }

// //
//   saveSession(String email) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.setString("email", email);
//     await pref.setBool("is_login", true);
//     bool isEmail(String email) => EmailValidator.validate(email);

//     bool isPhone(String input) =>
//         RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{16,}$')
//             .hasMatch(input);
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext context) => RegisterPage(),
//       ),
//       (route) => false,
//     );
//   }

//   void ceckLogin() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     var islogin = pref.getBool("is_login");
//     if (islogin != null && islogin) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (BuildContext context) => RegisterPage(),
//         ),
//         (route) => false,
//       );
//     }
//   }

//   @override
//   void initState() {
//     ceckLogin();
//     super.initState();
//   }

//   @override
//   dispose() {
//     super.dispose();
//   }

  // Widget _buildButton(BuildContext context) {
  //   return ElevatedButton.icon(
  //     style: ElevatedButton.styleFrom(
  //       primary: Colors.amber,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20.0),
  //         side: const BorderSide(color: Colors.blue),
  //       ),
  //       elevation: 10,
  //     ),
  //     onPressed: () => _validateInputs(),
  //     icon: const Icon(Icons.arrow_right_alt),
  //     label: const Text(
  //       "LOG IN",
  //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }
}
