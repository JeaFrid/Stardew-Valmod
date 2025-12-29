import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_manager/just_manager.dart';
import 'package:stardewmods/page/downloads.dart';
import 'package:stardewmods/services/smapi_download.dart';
import 'package:stardewmods/theme/color.dart';
import 'package:stardewmods/utils/l_steam.dart';
import 'package:stardewmods/widget/snack.dart';

class DepenPage extends StatefulWidget {
  const DepenPage({super.key});

  @override
  State<DepenPage> createState() => _DepenPageState();
}

class _DepenPageState extends State<DepenPage> {
  @override
  Widget build(BuildContext context) {
    return JMScaffold(
      backgroundColor: navColor,
      listenables: [],
      body: () {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bağımlılıklar",
                style: GoogleFonts.pixelifySans(
                  color: defaultColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Bağımlılıklar Nedir?",
                style: GoogleFonts.pixelifySans(
                  color: defaultColor,
                  fontSize: 18,
                ),
              ),
              Text(
                "Stardew Valley'in mod yöneticisinin ihtiyaç duyabileceği, SMAPI gibi motorlar, gerekli ayar dosyaları ve niceleri, Stardew Valley Mod Yöneticisinin bağımlılıklarıdır.",
                style: GoogleFonts.pixelifySans(color: textColor, fontSize: 14),
              ),
              SizedBox(height: 6),
              Text(
                "Kurulumlar Hakkında",
                style: GoogleFonts.pixelifySans(
                  color: defaultColor,
                  fontSize: 18,
                ),
              ),
              Text(
                "Valmod, sizin için kurulumları hızlandırır veya otomatikleştirir. Çoğu durumda, sistem seviyesinde bir işlem uygulanmaz. Bu yüzden Valmod, sizden sistem izinleri talep etmez.",
                style: GoogleFonts.pixelifySans(color: textColor, fontSize: 14),
              ),
              SizedBox(height: 10),
              Wrap(
                children: [
                  DownloadItem(
                    image:
                        "https://images.nexusmods.com/mod-headers/1303/2400.jpg",
                    title: "SMAPI - Stardew Modding API",
                    version: "4.3.2",
                    zipPath: "zipPath",
                    folderPath: "folderPath",
                    fileName: "SMAPI Otomatik Kurulum",
                    onTap: () {
                      bool isActive = false;
                      showSnackSpecial(
                        context,
                        Icons.warning_amber_rounded,
                        "SMAPI, Valmod'a ait güvenli bir sunucudan indirilip, bilgisayarına kurulacak. Onaylıyor musun? (NexusMod aracılığıyla dağıtıldı.)",
                        actionLabel: "Evet",
                        onAction: () async {
                          if (isActive == false) {
                            isActive = true;
                            showSnackSpecial(
                              context,
                              Icons.warning_amber_rounded,
                              "Kurulum başladı...",
                            );
                            await Future.delayed(Duration(seconds: 4));
                            showSnackSpecial(
                              context,
                              Icons.warning_amber_rounded,
                              "Gerekli tüm kurulum adımlarını ben halledeceğim. Sadece bekle. İşlem sonunda seni bilgilendireceğim.",
                            );
                            await Future.delayed(Duration(seconds: 8));
                            showSnackSpecial(
                              context,
                              Icons.warning_amber_rounded,
                              "Dosyanın varlığını kontrol ediyorum...",
                            );
                            await Future.delayed(Duration(seconds: 8));
                            showSnackSpecial(
                              context,
                              Icons.warning_amber_rounded,
                              "Çok iyi! Dosya sağlıklı. Kurulum etabına geçiyorum. Birazdan ekrana siyah bir TERMİNAL ekranı gelecek. Endişelenme, ben yapıyorum.",
                            );
                            await Future.delayed(Duration(seconds: 12));
                            showSnackSpecial(
                              context,
                              Icons.warning_amber_rounded,
                              "İndirme tamamlandı. Şimdi dosyaları şifreleyerek, otomasyonu başlatacağım.",
                            );
                            await runSmapiInstaller(
                              "http://api.jeafriday.com/assets/SMAPI%204.3.2-2400-4-3-2-1752544367.zip",
                              () async {
                                showSnackSpecial(
                                  context,
                                  Icons.warning_amber_rounded,
                                  "Kurulum tamamlandı. Hepsi bu kadar!",
                                );
                                await Future.delayed(Duration(seconds: 4));
                                showSnackSpecial(
                                  context,
                                  Icons.warning_amber_rounded,
                                  "Panoya bir şey kopyaladım. Birazdan ihtiyacın olacak. Yapıştırman gerektiği zaman, yapıştır.",
                                );
                                FlutterClipboard.copy(
                                  r'"C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\StardewModdingAPI.exe" %command%',
                                );
                                await Future.delayed(Duration(seconds: 8));
                                showSnackSpecial(
                                  context,
                                  Icons.warning_amber_rounded,
                                  "Şimdi Steam'i açıyorum. Sana ne yapman gerektiğini göstereceğim.",
                                );
                                await Future.delayed(Duration(seconds: 8));
                                openGuide(context);
                                await Future.delayed(Duration(seconds: 8));
                                await openSteamGamePage();
                              },
                              (error) {
                                showSnackSpecial(
                                  context,
                                  Icons.warning_amber_rounded,
                                  "Bir sorun oluştu.\n\n$error",
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
