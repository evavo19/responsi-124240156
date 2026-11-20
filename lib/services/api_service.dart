import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _base = 'https://potterapi-fedeperin.vercel.app/en';

  static Future<List<Map<String, dynamic>>> getBooks() async {
    final res = await http.get(Uri.parse('$_base/books'));
    if (res.statusCode != 200) throw Exception('Gagal memuat buku');
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }

  static Future<Map<String, dynamic>> getBookByIndex(int index) async {
    final res = await http.get(Uri.parse('$_base/books?index=$index'));
    if (res.statusCode != 200) throw Exception('Gagal memuat detail buku');
    return Map<String, dynamic>.from(jsonDecode(res.body));
  }

  static Future<List<Map<String, dynamic>>> getSpells() async {
    final res = await http.get(Uri.parse('$_base/spells'));
    if (res.statusCode != 200) throw Exception('Gagal memuat mantra buku');
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }
}
