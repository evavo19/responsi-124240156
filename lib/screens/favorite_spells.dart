import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/notification.dart';

class FavoriteSpellsPage extends StatelessWidget {
  const FavoriteSpellsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('favorites');

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        foregroundColor: Colors.white,
        title: Text(
          'Favorite Spells',
          style: GoogleFonts.uncialAntiqua(
            fontSize: 20,
            color: const Color(0xFFFACC15),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box b, _) {
          // Tampilan saat belum ada spell yang difavoritkan
          if (b.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 72, color: Color(0xFFFACC15)),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada spell yang difavoritkan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tekan ikon hati di halaman Spells\nuntuk menambahkannya ke sini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            );
          }

          final keys = b.keys.toList();
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: keys.length,
            itemBuilder: (context, i) {
              final key = keys[i];
              final data = Map<String, dynamic>.from(b.get(key));
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading:
                      const Icon(Icons.auto_fix_high, color: Color(0xFFFACC15)),
                  title: Text(
                    data['spell'] ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      data['use'] ?? '-',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      await b.delete(key);
                      await NotificationService.showDeleteNotification(
                        data['spell'] ?? '',
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
