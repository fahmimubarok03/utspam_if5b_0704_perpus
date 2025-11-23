import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrasi Pengguna")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildField("Nama Lengkap"),
                _buildField("NIK"),
                _buildField("Email"),
                _buildField("Alamat"),
                _buildField("Nomor Telepon"),
                _buildField("Username"),
                _buildField("Password", isPassword: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Daftar"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        obscureText: isPassword,
      ),
    );
  }
}
