import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
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

  String? validateEmail(String? value) {
    if (value == null || !value.contains("@gmail.com")) {
      return "Gunakan email @gmail.com";
    }
    return null;
  }

  String? validateNumber(String? value) {
    if (value == null || value.isEmpty || int.tryParse(value) == null) {
      return "Harus berupa angka";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return "Minimal 6 karakter";
    }
    return null;
  }

  Future<void> registerUser() async {
    setState(() => errorMessage = "");
    if (!_formKey.currentState!.validate()) return;

    final db = await DatabaseHelper.instance.database;
    final existing = await db.query('users',
        where: 'email = ? OR username = ? OR nik = ?',
        whereArgs: [emailCtrl.text, usernameCtrl.text, nikCtrl.text]);
    if (existing.isNotEmpty) {
      setState(() => errorMessage = "Email / Username / NIK sudah digunakan!");
      return;
    }

    await DatabaseHelper.instance.insertUser({
      'name': nameCtrl.text,
      'nik': nikCtrl.text,
      'email': emailCtrl.text,
      'address': addressCtrl.text,
      'phone': phoneCtrl.text,
      'username': usernameCtrl.text,
      'password': passwordCtrl.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registrasi Berhasil!")));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi Pengguna")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            _inputField(nameCtrl, "Nama Lengkap"),
            _inputField(nikCtrl, "NIK", validator: validateNumber),
            _inputField(emailCtrl, "Email", validator: validateEmail),
            _inputField(addressCtrl, "Alamat"),
            _inputField(phoneCtrl, "Nomor Telepon", validator: validateNumber),
            _inputField(usernameCtrl, "Username"),
            _passwordField(),
            if (errorMessage.isNotEmpty)
              Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(errorMessage, style: const TextStyle(color: Colors.red))),
            ElevatedButton(onPressed: registerUser, child: const Text("Daftar")),
          ]),
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String label, {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) return "Tidak boleh kosong";
          if (validator != null) return validator(value);
          return null;
        },
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), errorStyle: const TextStyle(color: Colors.red)),
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
          border: const OutlineInputBorder(),
          errorStyle: const TextStyle(color: Colors.red),
          suffixIcon: IconButton(
            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
        ),
      ),
    );
  }
}
