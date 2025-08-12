import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api/authApi.dart'; // Pastikan path ini benar
import '../screen/LoginScreen.dart'; // Ganti dengan path yang sesuai

class DaftarScreen extends StatefulWidget {
  @override
  _DaftarScreenState createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomorAnggotaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  FToast fToast = FToast();

  void _daftar() async {
    if (_formKey.currentState!.validate()) {
      String nomorAnggota = _nomorAnggotaController.text;
      String password = _passwordController.text;
      String konfirmasiPassword = _konfirmasiPasswordController.text;

      // Memanggil API untuk pendaftaran
      var response = await AuthApi.register(
        nomorAnggota,
        password,
        konfirmasiPassword,
      );

      if (response['status'] == 201) {
        // Pendaftaran berhasil
        Fluttertoast.showToast(
          msg: "Pendaftaran berhasil!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        // Arahkan pengguna ke layar login atau beranda
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // Pendaftaran gagal
        Fluttertoast.showToast(
          msg: response['messages']['error'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      'Wah Coopers baru?\nDaftar dulu ya Coopers!',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  Flexible(
                    flex: 1,
                    child: Image.asset(
                      "assets/image/juko_merah.png",
                      width: MediaQuery.of(context).size.width * 1,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomorAnggotaController,
                      decoration: InputDecoration(labelText: 'Nomor Anggota '),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nomor anggota tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _konfirmasiPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Mohon masukkan kembali password anda';
                        }
                        if (value != _passwordController.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _daftar,
                      child: Text(
                        'Daftar',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[900],
                        minimumSize: Size(200, 40),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//KODE YG LAMA//

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     resizeToAvoidBottomInset: false,
//     body: SafeArea(
//       child: Stack(
//         children: [
//           Positioned(
//             right: -100,
//             top: 0,
//             bottom: 300,
//             child: Image.asset(
//               "assets/image/juko_merah.png",
//               width: MediaQuery.of(context).size.width * 0.9,
//               fit: BoxFit.contain,
//             ),
//           ),
//           Positioned(
//             left: 29,
//             top: MediaQuery.of(context).size.height * 0.2,
//             child: Text(
//               'Wah Coopers baru? \nDaftar dulu ya Coopers!',
//               style: TextStyle(
//                 fontSize: 15,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Positioned(
//             left: 16,
//             right: 16,
//             top: MediaQuery.of(context).size.height * 0.5,
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _nomorAnggotaController,
//                     decoration: InputDecoration(
//                       labelText: 'Nomor Anggota',
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Nomor anggota tidak boleh kosong';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16),
//                   TextFormField(
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                     ),
//                     obscureText: true,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Password tidak boleh kosong';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16),
//                   TextFormField(
//                     controller: _konfirmasiPasswordController,
//                     decoration: InputDecoration(
//                       labelText: 'Konfirmasi Password',
//                     ),
//                     obscureText: true,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Mohon masukkan kembali password anda';
//                       }
//                       if (value != _passwordController.text) {
//                         return 'Password tidak cocok';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 20),
// ElevatedButton(
//   onPressed: _daftar,
//   child: Text(
//     'Daftar',
//     style: TextStyle(
//       fontFamily: 'Poppins',
//       fontSize: 16,
//       color: Colors.white,
//     ),
//   ),
//   style: ElevatedButton.styleFrom(
//     backgroundColor: Colors.green[900],
//     minimumSize: Size(200, 40),
//   ),
// ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
