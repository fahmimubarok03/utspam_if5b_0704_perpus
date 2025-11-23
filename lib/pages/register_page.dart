import 'package:flutter/material.dart';
import 'login_page.dart';
import '/database/database_helper.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final nikCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool _showPassword = false;
  String errorMessage = "";

  // ------- VALIDASI FORM -------
  String? validateEmail(String? value) {
    if (!value!.contains("@gmail.com")) {
      return "Gunakan email @gmail.com";
    }
    return null;
  }

  String? validateNik(String? value) {
    if (value == null || value.isEmpty) {
      return "NIK wajib diisi!";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "NIK harus angka";
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Nomor Telepon wajib diisi!";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Nomor Telepon harus angka";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.length < 6) {
      return "Minimal 6 karakter";
    }
    return null;
  }

  // ------- SIMPAN USER KE SQLITE -------
  Future<void> registerUser() async {
    final db = DatabaseHelper.instance;

    final users = await db.getUsers();

    for (var u in users) {
      if (u['email'] == emailCtrl.text) {
        setState(() => errorMessage = "Email sudah digunakan!");
        return;
      }
      if (u['username'] == usernameCtrl.text) {
        setState(() => errorMessage = "Username sudah digunakan!");
        return;
      }
      if (u['nik'] == nikCtrl.text) {
        setState(() => errorMessage = "NIK sudah digunakan!");
        return;
      }
    }

    await db.insertUser({
      'name': nameCtrl.text,
      'nik': nikCtrl.text,
      'email': emailCtrl.text,
      'address': addressCtrl.text,
      'phone': phoneCtrl.text,
      'username': usernameCtrl.text,
      'password': passwordCtrl.text,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Registrasi Berhasil!")));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrasi Pengguna")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _inputField(nameCtrl, "Nama Lengkap"),
                _inputField(nikCtrl, "NIK", validator: validateNik),
                _inputField(emailCtrl, "Email", validator: validateEmail),
                _inputField(addressCtrl, "Alamat"),
                _inputField(
                  phoneCtrl,
                  "Nomor Telepon",
                  validator: validatePhone,
                ),
                _inputField(usernameCtrl, "Username"),
                _passwordField(),

                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                ElevatedButton(
                  onPressed: () {
                    setState(() => errorMessage = "");
                    if (_formKey.currentState!.validate()) {
                      registerUser();
                    }
                  },
                  child: Text("Daftar"),
                ),

                TextButton(
                  child: const Text("Sudah punya akun? Login"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) return "Tidak boleh kosong";
          if (validator != null) return validator(value);
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          errorStyle: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: passwordCtrl,
        validator: validatePassword,
        obscureText: !_showPassword,
        decoration: InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(),
          errorStyle: TextStyle(color: Colors.red),
          suffixIcon: IconButton(
            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() => _showPassword = !_showPassword);
            },
          ),
        ),
      ),
    );
  }
}
