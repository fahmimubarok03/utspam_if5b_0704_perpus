import 'package:flutter/material.dart';
import '/database/database_helper.dart';
import 'register_page.dart';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final loginCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String errorMessage = '';
  bool _showPassword = false;

  Future<void> loginUser() async {
    final db = await DatabaseHelper.instance.database;

    String loginInput = loginCtrl.text.trim();
    String password = passCtrl.text.trim();

    if (loginInput.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "Semua field harus diisi!");
      return;
    }

    final result = await db.query(
      'users',
      where: "(email = ? OR nik = ?) AND password = ?",
      whereArgs: [loginInput, loginInput, password],
    );

    if (result.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('name', result[0]['name'].toString());
      // Simpan nama user sebagai session

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      setState(() => errorMessage = "Email/NIK atau Password salah!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Pengguna")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: loginCtrl,
                  decoration: const InputDecoration(
                    labelText: "Email atau NIK",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: passCtrl,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _showPassword = !_showPassword),
                    ),
                  ),
                ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: loginUser,
                  child: const Text("Login"),
                ),

                TextButton(
                  child: const Text("Belum punya akun? Registrasi"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterPage()),
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
}
