import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'book_list_page.dart';
import 'history_page.dart';
import 'profile_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? "Pengguna";
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
  }

  Widget _menuButton(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Halaman Utama"), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Halo, $userName 👋", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _menuButton(Icons.book, "Daftar Buku", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const BookListPage()));
          }),
          _menuButton(Icons.add, "Tambah Pinjam Buku", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const BookListPage()));
          }),
          _menuButton(Icons.history, "Riwayat Pinjam Buku", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage()));
          }),
          _menuButton(Icons.person, "Profil Pengguna", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
          }),
          const Spacer(),
          ElevatedButton(onPressed: logout, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("Logout")),
        ]),
      ),
    );
  }
}
