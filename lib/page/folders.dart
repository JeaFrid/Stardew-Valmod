import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_manager/just_manager.dart';
import 'package:stardewmods/page/downloads.dart';
import 'package:stardewmods/theme/color.dart';
import 'package:stardewmods/utils/folder_system.dart';
import 'package:stardewmods/utils/get_download.dart';
import 'package:stardewmods/widget/pressable.dart';
import 'package:stardewmods/widget/snack.dart';

void getFold() {
  folders().clear();
  Future.delayed(Durations.short2);
  folders.up();
  List<String> list = ModFolderManager.getFolderList();
  for (var element in list) {
    folders().add(FolderItem(title: element));
  }
  folders.up();
}

Pressable _btn(String title, IconData icon, Function() onTap) {
  return Pressable(
    onTap: onTap,
    child: Container(
      width: 220,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,

        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 18),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.pixelifySans(color: textColor),
            ),
          ),
        ],
      ),
    ),
  );
}

class FolderItem extends StatefulWidget {
  final String title;
  const FolderItem({super.key, required this.title});

  @override
  State<FolderItem> createState() => _FolderItemState();
}

class _FolderItemState extends State<FolderItem> {
  BuildContext? topContext;
  @override
  Widget build(BuildContext context) {
    topContext = context;
    return Tooltip(
      message: widget.title,
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
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          widget.title,
                          style: GoogleFonts.pixelifySans(
                            color: defaultColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      _btn("Klasör İçeriğini Görüntüle", Icons.folder_copy, () {
                        Navigator.pop(context);
                        var elements = ModFolderManager.getModsInFolder(
                          widget.title,
                        );
                        List<Widget> items = [];
                        for (var element in elements) {
                          items.add(
                            DownloadItem(
                              image: element["image_url"],
                              title: element["title"],
                              version: element["version"],
                              zipPath: element["zip_path"],
                              folderPath: element["folder_path"],
                              fileName: element["file_name"],
                              onTap: () async {
                                showSnackSpecial(
                                  topContext ?? context,
                                  Icons.crisis_alert_sharp,
                                  "Bu modu kaldırmak için uzun bir süre basılı tut.",
                                );
                              },
                              onLongTap: () async {
                                Navigator.pop(topContext ?? context);
                                showSnackSpecial(
                                  topContext ?? context,
                                  Icons.check,
                                  "Mod, klasörden çıkarıldı.",
                                );
                                await ModFolderManager.removeModFromFolder(
                                  widget.title,
                                  element["zip_path"],
                                );
                              },
                            ),
                          );
                        }
                        showModalBottomSheet(
                          enableDrag: true,
                          useSafeArea: true,
                          backgroundColor: Colors.transparent,
                          context: topContext ?? context,
                          builder: (context) {
                            return IntrinsicHeight(
                              child: Container(
                                height: 300,
                                width: 350,
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
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          "${widget.title} klasöründen çıkarmak istediğin modun üzerine uzun bir şekilde tıkla.",
                                          style: GoogleFonts.pixelifySans(
                                            color: textColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Column(children: items),
                                      SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                      _btn(
                        "Kütüphaneden Mod Ekle",
                        Icons.post_add_rounded,
                        () async {
                          Navigator.pop(context);

                          Future.delayed(Durations.short2);
                          var list = await getAllDownloadedMods();
                          List<Widget> items = [];
                          for (var element in list) {
                            items.add(
                              DownloadItem(
                                image: element["image_url"],
                                title: element["title"],
                                version: element["version"],
                                zipPath: element["zip_path"],
                                folderPath: element["folder_path"],
                                fileName: element["file_name"],
                                onTap: () async {
                                  Navigator.pop(topContext ?? context);
                                  await ModFolderManager.addModToFolder(
                                    widget.title,
                                    element,
                                  );
                                  if (!(topContext ?? context).mounted) return;
                                  showSnackSpecial(
                                    topContext ?? context,
                                    Icons.add,
                                    "Mod, ${widget.title} adlı klasöre eklendi.",
                                  );
                                },
                              ),
                            );
                          }
                          if (!(topContext ?? context).mounted) return;
                          showModalBottomSheet(
                            enableDrag: true,
                            useSafeArea: true,
                            backgroundColor: Colors.transparent,
                            context: topContext ?? context,
                            builder: (context) {
                              return IntrinsicHeight(
                                child: Container(
                                  height: 300,
                                  width: 350,
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
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 4),
                                        Column(children: items),
                                        SizedBox(height: 4),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      _btn("Klasörü Aktifleştir", Icons.check, () async {
                        Navigator.pop(topContext ?? context);
                        showSnackSpecial(
                          topContext ?? context,
                          Icons.warning_amber_rounded,
                          "Oyun geneline bu mod dosyası yüklenecek ve önceki modlar rafa kaldırılacak. Emin misin?",
                          actionLabel: "Evet!!!",
                          onAction: () async {
                            await ModFolderManager.installAllModsInFolder(
                              widget.title,
                              () {
                                showSnackSpecial(
                                  topContext ?? context,
                                  Icons.check,
                                  "Mod klasörü aktifleştirildi!",
                                );
                              },
                              (e) {
                                print(e);
                                showSnackSpecial(
                                  topContext ?? context,
                                  Icons.check,
                                  "Bir problem oluştu.",
                                );
                              },
                            );
                          },
                        );
                      }),
                      _btn("Klasörü Sil", Icons.remove, () {
                        final String folderToDelete = widget.title;

                        Navigator.pop(topContext ?? context);

                        showSnackSpecial(
                          topContext ?? context,
                          Icons.warning_amber_rounded,
                          "Klasör ve iç yapısı kalıcı olarak silinecek. Bu işlem, indirilen modlara zarar vermez.",
                          actionLabel: "Eminim.",
                          onAction: () async {
                            if (ModFolderManager.folderExists(folderToDelete)) {
                              await ModFolderManager.deleteFolder(
                                folderToDelete,
                              );
                              showSnackSpecial(
                                topContext ?? context,
                                Icons.check,
                                "Mod klasörü silindi.",
                              );
                              getFold();
                            } else {
                              showSnackSpecial(
                                topContext ?? context,
                                Icons.sms_failed_outlined,
                                "Az önce bu klasörü silmedin mi zaten? Yoksa halüsinasyon mu görüyorum?",
                              );
                            }
                          },
                        );
                      }),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Column(
          children: [
            Image.asset(
              "assets/image/open-folder.png",
              width: 100,
              height: 100,
              color: textColor,
            ),
            SizedBox(
              width: 100,
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.pixelifySans(color: textColor, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

JM<List<Widget>> folders = JM([]);

class Folders extends StatefulWidget {
  const Folders({super.key});

  @override
  State<Folders> createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
  @override
  void initState() {
    super.initState();
    getFold();
  }

  @override
  Widget build(BuildContext context) {
    return JMScaffold(
      backgroundColor: navColor,
      listenables: [folders],
      body: () {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Klasörlerim",
                          style: GoogleFonts.pixelifySans(
                            color: defaultColor,
                            fontSize: 22,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Text(
                                  "Yeni klasör oluşturmak için ",
                                  style: GoogleFonts.pixelifySans(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                              WidgetSpan(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 6),
                                  width: 20,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: defaultColor,
                                  ),
                                ),
                              ),
                              WidgetSpan(
                                child: Text(
                                  "'e tıkla!",
                                  style: GoogleFonts.pixelifySans(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              WidgetSpan(
                                child: Text(
                                  " (Bak hemen sağ üst köşede!!)",
                                  style: GoogleFonts.pixelifySans(
                                    color: textColor.withOpacity(0.5),
                                    fontSize: 12,
                                  ),
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
              Wrap(children: folders()),
            ],
          ),
        );
      },
    );
  }
}
