import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:just_manager/just_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stardewmods/page/folders.dart';
import 'package:stardewmods/page/general.dart';
import 'package:stardewmods/services/steam_launcher.dart';
import 'package:stardewmods/theme/color.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stardewmods/utils/folder_system.dart';
import 'package:stardewmods/widget/pressable.dart';
import 'package:stardewmods/widget/snack.dart';
import 'package:stardewmods/widget/textfield.dart';
import 'package:stardewmods/widget/visibility.dart';

WebViewEnvironment? webViewEnvironment;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Directory appSupportDir = await getApplicationSupportDirectory();
  final String webViewDataPath = '${appSupportDir.path}\\WebView2Data';
  webViewEnvironment = await WebViewEnvironment.create(
    settings: WebViewEnvironmentSettings(userDataFolder: webViewDataPath),
  );
  await Hive.initFlutter();
  await Hive.openBox('mods');
  await Hive.openBox('virtual_folders');
  runApp(const MyApp());

  doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = const Size(1024, 768);
    win.maxSize = const Size(1024, 768);
    win.size = const Size(1024, 768);
    win.alignment = Alignment.center;
    win.title = "Stardew Valmod";
    win.show();
  });
}

TextEditingController folderName = TextEditingController();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StardewMods',

      home: Scaffold(
        body: Stack(children: [const CustomWindowLayout(child: GeneralPage())]),
      ),
    );
  }
}

class CustomWindowLayout extends StatelessWidget {
  final Widget child;

  const CustomWindowLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return JMScaffold(
      listenables: [funcButton],
      body: () => WindowBorder(
        color: const Color(0xFF8B4513),
        width: 1,
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Container(
                color: bg,
                child: Row(
                  children: [
                    Expanded(
                      child: MoveWindow(
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "StardewMods",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Pressable(
                      onTap: () {
                        bool isActive = false;
                        showSnackSpecial(
                          context,
                          Icons.warning_amber_rounded,
                          "Stardew Valley oyununu Steam üzerinden açmak üzereyim. Bu işlem sonrasında Valmod kapatılacak. Emin misin?",
                          actionLabel: "Evet",
                          onAction: () async {
                            if (isActive == false) {
                              isActive = true;
                              await launchStardewValley();
                              if (!context.mounted) return;
                              showSnackSpecial(
                                context,
                                Icons.warning_amber_rounded,
                                "İyi, ben gidiyom. Hoşça kal!",
                              );
                              await Future.delayed(Durations.extralong4);
                              if (!context.mounted) return;
                              showSnackSpecial(
                                context,
                                Icons.warning_amber_rounded,
                                "3",
                              );
                              await Future.delayed(Durations.extralong4);
                              if (!context.mounted) return;
                              showSnackSpecial(
                                context,
                                Icons.warning_amber_rounded,
                                "2",
                              );
                              await Future.delayed(Durations.extralong4);
                              if (!context.mounted) return;
                              showSnackSpecial(
                                context,
                                Icons.warning_amber_rounded,
                                "1",
                              );
                              await Future.delayed(Durations.extralong4);
                              appWindow.close();
                            }
                          },
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        width: 40,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    AnimatedVisibility(
                      visible: funcButton(),
                      child: Pressable(
                        onTap: () {
                          showModalBottomSheet(
                            enableDrag: true,
                            useSafeArea: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return IntrinsicHeight(
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: bg,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    border: Border.all(
                                      color: textColor.withOpacity(0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 4),
                                      textfield(
                                        text: "Klasör Adı",
                                        textController: folderName,
                                        onSucccess: () {
                                          if (folderName.text
                                              .trim()
                                              .isNotEmpty) {
                                            ModFolderManager.createFolder(
                                              folderName.text.trim(),
                                            );
                                            Navigator.pop(context);
                                            getFold();
                                          }
                                        },
                                        onSucccessIcon: Icons.check,
                                      ),
                                      SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          width: 40,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: defaultColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Pressable(
                      onTap: () {
                        appWindow.close();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        width: 40,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xffe81123),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                  ],
                ),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

JM<bool> funcButton = JM(false);
void setFuncButton(bool status) {
  funcButton.set(status);
}
