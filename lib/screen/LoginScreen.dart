import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/authAPI.dart';
import '../screen/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = "", _password = "";
  bool _waiting = false;
  bool _obscurePassword = true;

  void _setWaiting() {
    setState(() {
      _waiting = !_waiting;
    });
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _setWaiting();

      try {
        // Pemanggilan API login
        var loginResponse = await AuthApi.login(_username, _password);

        // Cek apakah kita mendapatkan respons dari API
        print("Login Response: $loginResponse");

        // Periksa apakah status yang diterima dari API adalah 200
        if (loginResponse['status'] == 200) {
          // Simpan informasi login di SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
            'nomor_anggota',
            loginResponse['data']['nomor_anggota'],
          );
          await prefs.setString('username', loginResponse['data']['username']);
          await prefs.setString('nama', loginResponse['data']['nama']);
          await prefs.setString('jurusan', loginResponse['data']['jurusan']);

          // Tampilkan pesan sukses dan arahkan ke halaman Home
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginResponse['messages']),
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          // Tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginResponse['messages'].toString()),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (error) {
        // Tangkap dan tampilkan kesalahan
        print("Error during login: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Terjadi kesalahan: $error"),
            duration: const Duration(seconds: 2),
          ),
        );
      } finally {
        _setWaiting(); // Selalu matikan loading setelah proses selesai
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
              Center(
                child: Image.asset(
                  "assets/image/juko_merah.png",
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Silahkan Login!',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username tidak boleh kosong';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
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
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),

                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _waiting ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[900],
                        minimumSize: Size(200, 48),
                      ),
                      child: Text(
                        _waiting ? 'Tunggu...' : 'Login',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.white,
                        ),
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
