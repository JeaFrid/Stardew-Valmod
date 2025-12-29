import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchStardewValley() async {
  final Uri url = Uri.parse('steam://run/413150');

  try {
    if (!await launchUrl(url)) {
      throw Exception('Oyun başlatılamadı $url');
    }
  } catch (e) {
    debugPrint('Hata: $e');
  }
}
