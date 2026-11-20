import 'dart:async';

import 'package:flutter/material.dart';

// Dipakai di main.dart supaya kita bisa menampilkan pesan melayang
// di atas halaman mana pun (termasuk setelah pindah halaman saat logout).
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Tetap dipertahankan agar main.dart yang lama tidak error.
final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

OverlayEntry? _entry;
Timer? _timer;

// Nama fungsi tetap showAppSnackBar, jadi file lain tidak perlu diubah.
// Pesan melayang di atas layar, sudut membulat (hijau = sukses, merah = gagal).
void showAppSnackBar(String title, String message, {required bool success}) {
  final overlay = navigatorKey.currentState?.overlay;
  if (overlay == null) return;

  _timer?.cancel();
  _entry?.remove();

  _entry = OverlayEntry(
    builder: (context) {
      final topInset = MediaQuery.of(context).padding.top;
      return Positioned(
        top: topInset + 8,
        left: 12,
        right: 12,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: success ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(_entry!);

  // Hilang otomatis setelah 2 detik
  _timer = Timer(const Duration(seconds: 2), () {
    _entry?.remove();
    _entry = null;
  });
}
