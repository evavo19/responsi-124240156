import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';
import '../utils/app_snackbar.dart';
import 'favorite_spells.dart';
import 'login.dart';

class SpellsPage extends StatefulWidget {
  const SpellsPage({super.key});

  @override
  State<SpellsPage> createState() => _SpellsPageState();
}

class _SpellsPageState extends State<SpellsPage> {
  late Future<List<Map<String, dynamic>>> _future;
  final Box _box = Hive.box('favorites');

  @override
  void initState() {
    super.initState();
    _future = ApiService.getSpells();
  }

  void _toggleFavorite(Map<String, dynamic> spell) {
    final name = spell['spell'] as String;
    if (_box.containsKey(name)) {
      _box.delete(name);
      showAppSnackBar(
        'Remove!',
        '$name removed from fav list!',
        success: false,
      );
    } else {
      _box.put(name, {'spell': name, 'use': spell['use'] ?? ''});
      showAppSnackBar(
        'Add!',
        '$name successfully added to fav list!',
        success: true,
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
    showAppSnackBar('Success!', 'Logged out Successfully', success: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        foregroundColor: Colors.white,
        title: Text(
          'Harry Potter Spells Gallery',
          style: GoogleFonts.uncialAntiqua(
            fontSize: 15,
            color: const Color(0xFFFACC15),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFFACC15)),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 64),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF1E1B4B),
          foregroundColor: const Color(0xFFFACC15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFFACC15), width: 1),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoriteSpellsPage()),
          ),
          child: const Icon(Icons.favorite),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFACC15)),
                );
              }
              if (snap.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snap.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              final list = snap.data!;
              return ValueListenableBuilder(
                valueListenable: _box.listenable(),
                builder: (context, Box box, _) {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 140),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final s = list[i];
                      final isFav = box.containsKey(s['spell']);
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          leading: const Icon(Icons.auto_fix_high,
                              color: Color(0xFFFACC15)),
                          title: Text(
                            s['spell'] ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              s['use'] ?? '-',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.redAccent : Colors.white54,
                            ),
                            onPressed: () => _toggleFavorite(s),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF312E81),
                      foregroundColor: const Color(0xFFFACC15),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Books',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
