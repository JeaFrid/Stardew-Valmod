import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stardewmods/widget/pressable.dart';

Future<void> openSteamGamePage() async {
  const String steamUrl = "steam://nav/games/details/413150";

  try {
    await Process.run('explorer', [steamUrl]);
    print("Steam sayfası açıldı.");
  } catch (e) {
    print("Steam açılamadı: $e");
  }
}

void openGuide(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Pressable(
        onTap: () {
          Navigator.pop(context);
        },
        child: Image.asset(
          "assets/image/rehber_steam.png",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      );
    },
  );
}
