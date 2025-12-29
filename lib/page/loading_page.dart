import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_manager/just_manager.dart';
import 'package:stardewmods/theme/color.dart';
import 'package:stardewmods/widget/gradient_mask.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return JMScaffold(
      backgroundColor: bg,
      listenables: [],
      body: () {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "Stardew\nValmod!",
                textAlign: TextAlign.center,
                style: GoogleFonts.pixelifySans(
                  color: defaultColor,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  height: 0.9,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Text(
                        "JeaFriday tarafından, insanlık için geliştirildi!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.pixelifySans(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 0.9,
                        ),
                      ),
                    ),
                    WidgetSpan(child: SizedBox(width: 4)),
                    WidgetSpan(
                      child: Image.asset(
                        "assets/image/love.png",
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 60),
              Image.asset("assets/image/loading.webp", width: 50, height: 50),
              Spacer(),
              SizedBox(height: 10),
              Opacity(
                opacity: 0.3,
                child: GradientMask(
                  colors: [textColor, defaultColor],
                  child: Text(
                    "Bu uygulama, bugün ve gelecekte, sonsuza dek ücretsiz olacaktır.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 14,
                      height: 0.9,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
