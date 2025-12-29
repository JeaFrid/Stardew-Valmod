import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_manager/just_manager.dart';
import 'package:stardewmods/main.dart';
import 'package:stardewmods/page/depen.dart';
import 'package:stardewmods/page/downloads.dart';
import 'package:stardewmods/page/folders.dart';
import 'package:stardewmods/page/home.dart';
import 'package:stardewmods/page/loading_page.dart';
import 'package:stardewmods/theme/color.dart';
import 'package:stardewmods/utils/general_settings.dart';
import 'package:stardewmods/widget/pressable.dart';
import 'package:stardewmods/widget/visibility.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({super.key});

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  JM<int> page = JM(0);
  @override
  void initState() {
    super.initState();
    page.addListener(() {
      if (page() == 2) {
        setFuncButton(true);
      } else {
        setFuncButton(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return JMScaffold(
      backgroundColor: bg,
      listenables: [page, GeneralSettingsUtils.isLoading],
      body: () {
        return Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 200,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/image/stardew.png", width: 100),
                          ],
                        ),
                        SizedBox(height: 8),
                        pageButton("Ana Sayfa", Icons.home, 0),
                        pageButton("Modlarım", Icons.all_inclusive, 1),
                        pageButton(
                          "Klasörlerim",
                          Icons.folder_copy_outlined,
                          2,
                        ),
                        pageButton("Bağımlılıklar", Icons.light_rounded, 3),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: IndexedStack(
                        index: page(),
                        children: [
                          HomePage(),
                          Downloads(),
                          Folders(),
                          DepenPage(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AnimatedVisibility(
              visible: GeneralSettingsUtils.isLoading(),
              child: LoadingPage(),
            ),
          ],
        );
      },
    );
  }

  Widget pageButton(String title, IconData icon, int pageIndex) {
    return Pressable(
      onTap: () {
        page.set(pageIndex);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: cColor,
          border: Border(
            bottom: BorderSide(color: textColor.withOpacity(0.5), width: 2),
          ),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          image: DecorationImage(
            image: pageIndex == page()
                ? AssetImage("assets/image/stardew_btn_color.jpg")
                : AssetImage("assets/image/stardew_btn_black.jpg"),
            fit: BoxFit.cover,
            opacity: pageIndex == page() ? 0.5 : 0.3,
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
