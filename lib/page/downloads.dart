import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_manager/just_manager.dart';
import 'package:stardewmods/theme/color.dart';
import 'package:stardewmods/utils/check_install.dart';
import 'package:stardewmods/utils/get_download.dart';
import 'package:stardewmods/utils/go_file_explorer.dart';
import 'package:stardewmods/utils/install_mod.dart';
import 'package:stardewmods/widget/pressable.dart';
import 'package:stardewmods/widget/snack.dart';
import 'package:url_launcher/url_launcher.dart';

JM<List<Widget>> downloadedMods = JM([]);
Future<void> getDownloadedMods() async {
  downloadedMods().clear();
  downloadedMods.up();
  Future.delayed(Durations.short2);
  var list = await getAllDownloadedMods();

  for (var element in list) {
    downloadedMods().add(
      DownloadItem(
        image: element["image_url"],
        title: element["title"],
        version: element["version"],
        zipPath: element["zip_path"],
        folderPath: element["folder_path"],
        fileName: element["file_name"],
      ),
    );
  }
  downloadedMods.up();
}

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.short2, () async {
      await getDownloadedMods();
    });
  }

  @override
  Widget build(BuildContext context) {
    return JMScaffold(
      backgroundColor: navColor,
      listenables: [downloadedMods],
      body: () {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Modlarım",
                      style: GoogleFonts.pixelifySans(
                        color: defaultColor,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Pressable(
                    onTap: () async {
                      await openStardewFolder();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: textColor.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.folder, color: defaultColor, size: 16),
                          SizedBox(width: 4),
                          Text(
                            "Klasöre Git",
                            style: GoogleFonts.pixelifySans(
                              color: defaultColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Wrap(children: downloadedMods()),
            ],
          ),
        );
      },
    );
  }
}

class DownloadItem extends StatefulWidget {
  final String image;
  final String title;
  final String version;
  final String zipPath;
  final String folderPath;
  final String fileName;
  final Function()? onTap;
  final Function()? onLongTap;
  const DownloadItem({
    super.key,
    required this.image,
    required this.title,
    required this.version,
    required this.zipPath,
    required this.folderPath,
    required this.fileName,
    this.onTap,
    this.onLongTap,
  });

  @override
  State<DownloadItem> createState() => _DownloadItemState();
}

class _DownloadItemState extends State<DownloadItem> {
  JM<bool> errorImage = JM(false);
  JM<bool> isModInstall = JM(false);
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 25), () async {
      isModInstall.set(await isModInstalled(widget.folderPath));
    });
  }

  @override
  Widget build(BuildContext context) {
    return JMListener(
      listenables: [errorImage, isModInstall],
      childBuilder: () {
        return Pressable(
          onTap:
              widget.onTap ??
              () {
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
                            if (!isModInstall())
                              _btn(
                                "Modu Otomatik Kur",
                                Icons.switch_access_shortcut_sharp,
                                () async {
                                  Navigator.pop(context);
                                  installMod(
                                    widget.folderPath,
                                    widget.fileName,
                                    () async {
                                      showSnackSpecial(
                                        context,
                                        Icons.check,
                                        "Kurulum tamamlandı!",
                                      );
                                      await getDownloadedMods();
                                    },
                                    (e) {
                                      showSnackSpecial(
                                        context,
                                        Icons.error_outline,
                                        "Bir sorun oluştu.",
                                      );
                                    },
                                  );
                                },
                              ),
                            if (isModInstall())
                              _btn(
                                "Modu Kaldır",
                                Icons.exit_to_app_outlined,
                                () async {
                                  Navigator.pop(context);
                                  deleteMod(
                                    widget.fileName,
                                    () async {
                                      showSnackSpecial(
                                        context,
                                        Icons.check,
                                        "Mod oyundan kaldırıldı.",
                                      );
                                      await getDownloadedMods();
                                    },
                                    (e) {
                                      showSnackSpecial(
                                        context,
                                        Icons.error_outline,
                                        "Bir sorun oluştu.",
                                      );
                                    },
                                  );
                                },
                              ),
                            if (!isModInstall())
                              _btn(
                                "Modu Kalıcı Olarak Sil",
                                Icons.delete_forever_rounded,
                                () async {
                                  Navigator.pop(context);
                                  removeDownloadedModFiles(
                                    widget.folderPath,
                                    widget.fileName,
                                    () async {
                                      showSnackSpecial(
                                        context,
                                        Icons.check,
                                        "Mod kalıcı olarak kaldırıldı.",
                                      );
                                      await getDownloadedMods();
                                    },
                                    (e) {
                                      showSnackSpecial(
                                        context,
                                        Icons.error_outline,
                                        "Bir sorun oluştu.",
                                      );
                                    },
                                  );
                                },
                              ),
                            _btn(
                              "Mod Bağlantısını Kopyala",
                              Icons.shape_line,
                              () async {
                                Navigator.pop(context);
                              },
                            ),
                            _btn(
                              "Mod Görselini İndir",
                              Icons.image_search_sharp,
                              () async {
                                Navigator.pop(context);
                                if (await canLaunchUrl(
                                  Uri.parse(widget.image),
                                )) {
                                  await launchUrl(Uri.parse(widget.image));
                                }
                              },
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
          onLongPress: widget.onLongTap,
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(6),
            width: 350,
            decoration: BoxDecoration(
              color: cColor,
              image: DecorationImage(
                image: errorImage()
                    ? AssetImage("assets/image/stardew_btn_black.jpg")
                    : NetworkImage(widget.image),
                fit: BoxFit.cover,
                opacity: 0.2,
                onError: (exception, stackTrace) {
                  errorImage.set(true);
                },
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border(
                bottom: BorderSide(color: textColor.withOpacity(0.2), width: 2),
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.image,
                    width: 40,
                    fit: BoxFit.cover,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/image/stardew.png",
                        width: 40,
                        height: 40,
                      );
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Tooltip(
                    message: widget.title,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.pixelifySans(
                            color: textColor,
                            fontSize: 16,
                          ),
                        ),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Version: ",
                                style: GoogleFonts.pixelifySans(
                                  color: textColor,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: widget.version,
                                style: GoogleFonts.pixelifySans(
                                  color: textColor.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: ", Dosya: ",
                                style: GoogleFonts.pixelifySans(
                                  color: textColor,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: widget.fileName,
                                style: GoogleFonts.pixelifySans(
                                  color: textColor.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Visibility(
                  visible: widget.onTap == null,
                  child: Tooltip(
                    message: isModInstall()
                        ? "Bu mod yüklü."
                        : "Bu mod yüklü değil.",
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isModInstall() ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
}
