import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String _base = 'https://potterapifedeperin.vercel.app/en/books';

  static Future<List<Map<String, dynamic>>> _getList(String path) async {
    final res = await http.get(Uri.parse('$_base/$path'));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat data (${res.statusCode})');
    }
    final List data = jsonDecode(res.body);
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<List<Map<String, dynamic>>> getCharacters() =>
      _getList('characters');

  static Future<List<Map<String, dynamic>>> getSpells() => _getList('spells');
}
