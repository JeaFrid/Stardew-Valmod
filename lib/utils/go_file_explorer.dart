import 'dart:io';
import 'package:flutter/material.dart';

Future<void> openStardewFolder() async {
  const String path =
      r'C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley';
  final Directory directory = Directory(path);

  if (await directory.exists()) {
    await Process.run('explorer', [path]);
  } else {
    debugPrint('Hata: Klasör bu yolda bulunamadı: $path');
  }
}
