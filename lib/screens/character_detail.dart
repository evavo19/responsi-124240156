import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CharacterDetailPage extends StatelessWidget {
  final Map<String, dynamic> character;
  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final children = (character['children'] as List?)?.join(', ') ?? '-';

    final rows = <MapEntry<String, String>>[
      MapEntry('Index', '${character['index'] ?? '-'}'),
      MapEntry('Full Name', '${character['fullName'] ?? '-'}'),
      MapEntry('Nickname', '${character['nickname'] ?? '-'}'),
      MapEntry('Hogwarts House', '${character['hogwartsHouse'] ?? '-'}'),
      MapEntry('Interpreted By', '${character['interpretedBy'] ?? '-'}'),
      MapEntry('Children', children.isEmpty ? '-' : children),
      MapEntry('Birthdate', '${character['birthdate'] ?? '-'}'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        foregroundColor: Colors.white,
        title: Text(
          character['fullName'] ?? 'Detail',
          style: GoogleFonts.uncialAntiqua(
            fontSize: 20,
            color: const Color(0xFFFACC15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(color: const Color(0xFFFACC15), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  character['image'] ?? '',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (_, __, ___) => Container(
                    height: 320,
                    color: Colors.grey[800],
                    child: const Icon(Icons.person,
                        size: 120, color: Color(0xFFFACC15)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                children: [
                  for (final r in rows)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 130,
                            child: Text(
                              r.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFACC15),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              r.value,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
