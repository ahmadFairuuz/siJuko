import 'package:flutter/material.dart';

import '../api/BiodatAPI.dart';
import '../data_model/BiodataModel.dart';

class EditBiodataScreen extends StatefulWidget {
  @override
  _EditBiodataScreenState createState() => _EditBiodataScreenState();
}

class _EditBiodataScreenState extends State<EditBiodataScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _jenisKelaminController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();
  final TextEditingController _fakultasController = TextEditingController();
  final TextEditingController _nomorAnggotaController = TextEditingController();
  bool _waiting = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() => _waiting = true);
    BiodataModel biodata = await BiodataApi.getBiodata();
    setState(() {
      _nomorAnggotaController.text = biodata.nomorAnggota;
      _namaController.text = biodata.nama;
      _npmController.text = biodata.npm;
      _emailController.text = biodata.email;
      _nomorController.text = biodata.nomor_hp;
      _jenisKelaminController.text = biodata.jenisKelamin;
      _jurusanController.text = biodata.jurusan;
      _fakultasController.text = biodata.fakultas;
      _waiting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Biodata',
          style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
        ),
        backgroundColor: Colors.green[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _waiting
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nomor Anggota',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.green[900],
                      ),
                    ),
                    TextField(
                      readOnly: true,
                      controller: _nomorAnggotaController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField('Nama Lengkap', _namaController),
                    _buildTextField('NPM', _npmController),
                    _buildTextField('Email', _emailController),
                    _buildTextField('Nomor Handphone', _nomorController),
                    const SizedBox(height: 8),
                    Text(
                      'Jenis Kelamin',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.green[900],
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: _jenisKelaminController.text,
                      items: const [
                        DropdownMenuItem(
                          child: Text(
                            'Laki-laki',
                            style: TextStyle(color: Colors.black),
                          ),
                          value: 'L',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Perempuan',
                            style: TextStyle(color: Colors.black),
                          ),
                          value: 'P',
                        ),
                      ],
                      onChanged: (v) {
                        setState(() {
                          _jenisKelaminController.text = v!;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField('Jurusan', _jurusanController),
                    _buildTextField('Fakultas', _fakultasController),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.green[900],
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_namaController.text.isEmpty ||
                              _npmController.text.isEmpty ||
                              _emailController.text.isEmpty ||
                              _nomorController.text.isEmpty ||
                              _jenisKelaminController.text.isEmpty ||
                              _jurusanController.text.isEmpty ||
                              _fakultasController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mohon isi semua field'),
                              ),
                            );
                            return;
                          }

                          setState(() => _waiting = true);

                          BiodataModel bm = BiodataModel(
                            nomorAnggota: _nomorAnggotaController.text,
                            npm: _npmController.text,
                            nama: _namaController.text,
                            email: _emailController.text,
                            nomor_hp: _nomorController.text,
                            jenisKelamin: _jenisKelaminController.text,
                            jurusan: _jurusanController.text,
                            fakultas: _fakultasController.text,
                          );
                          final response = await BiodataApi.updateBiodata(bm);

                          setState(() => _waiting = false);

                          if (response['status'] == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Berhasil mengubah biodata'),
                              ),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(response['messages'].toString()),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontFamily: 'Poppins', color: Colors.green[900]),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
