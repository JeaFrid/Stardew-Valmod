import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:just_manager/just_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stardewmods/main.dart';
import 'package:stardewmods/page/downloads.dart';
import 'package:stardewmods/theme/color.dart';
import 'package:stardewmods/utils/general_settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InAppWebViewController? webViewController;
  JM<String> title = JM("");
  JM<String> version = JM("");
  JM<String> image = JM("");
  double progress = 0;
  JM<bool> isDownloading = JM(false);

  final String _jsScrapingCode = """
    (function() {
      function getText(selector) {
        var el = document.querySelector(selector);
        return el ? el.innerText.trim() : "";
      }
      function getImg(selector) {
        var el = document.querySelector(selector);
        return el ? (el.getAttribute('src') || el.getAttribute('data-src')) : "";
      }
      var title = getText("#pagetitle > h1");
      if (!title) return null;
      return {
        "title": title,
        "author": getText("#fileinfo > div:nth-child(4)"),
        "version": getText("#pagetitle > ul.stats.clearfix > li.stat-version > div > div.stat"),
        "image_url": getImg("#feature > div.img-wrapper.header-img > img"),
        "description": getText(".mod_description_container")
      };
    })();
  """;

  @override
  Widget build(BuildContext context) {
    return JMScaffold(
      backgroundColor: bg,
      listenables: [version, title, image],
      body: () {
        return Column(
          children: [
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri("https://www.nexusmods.com/stardewvalley"),
                ),
                webViewEnvironment: webViewEnvironment,
                initialSettings: InAppWebViewSettings(
                  supportZoom: true,
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  databaseEnabled: true,
                  useHybridComposition: true,
                  safeBrowsingEnabled: true,
                  allowContentAccess: true,
                  useShouldOverrideUrlLoading: true,
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  var urlString = uri.toString();

                  if (urlString.contains("nexus-cdn.com") ||
                      urlString.endsWith(".zip") ||
                      urlString.endsWith(".rar") ||
                      urlString.endsWith(".7z")) {
                    _downloadFile(url: urlString);
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  if (url == null) return;
                  if (url.toString().contains("/mods/") &&
                      !url.toString().contains("tab=")) {
                    _extractModData(controller);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadFile({required String url, String? filename}) async {
    isDownloading.set(true);
    GeneralSettingsUtils.setLoading(true);

    try {
      String finalFileName = filename ?? "mod_file.zip";
      if (filename == null) {
        try {
          final uri = Uri.parse(url);
          final pathSegments = uri.pathSegments;
          if (pathSegments.isNotEmpty) {
            finalFileName = Uri.decodeComponent(pathSegments.last);
          }
        } catch (_) {}
      }
      String folderName = finalFileName.replaceAll(
        RegExp(r'\.(zip|rar|7z)$'),
        '',
      );
      Directory? baseDir = await getDownloadsDirectory();
      baseDir ??= await getApplicationDocumentsDirectory();
      final targetDir = Directory(
        "${baseDir.path}${Platform.pathSeparator}StardewValmod${Platform.pathSeparator}$folderName",
      );
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }
      final savePath =
          "${targetDir.path}${Platform.pathSeparator}$finalFileName";
      final jsonPath =
          "${targetDir.path}${Platform.pathSeparator}$folderName.json";

      CookieManager cookieManager = CookieManager.instance();
      List<Cookie> cookies = await cookieManager.getCookies(url: WebUri(url));
      String cookieString = cookies
          .map((c) => "${c.name}=${c.value}")
          .join("; ");

      Dio dio = Dio();
      await dio.download(
        url,
        savePath,
        options: Options(
          headers: {
            "Cookie": cookieString,
            "User-Agent":
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
            "Referer": "https://www.nexusmods.com/",
          },
        ),
      );
      Map<String, dynamic> modInfo = {
        "title": title(),
        "version": version(),
        "image_url": image(),
        "downloaded_at": DateTime.now().toIso8601String(),
        "file_name": finalFileName,
        "folder_name": folderName,
      };

      File jsonFile = File(jsonPath);
      await jsonFile.writeAsString(jsonEncode(modInfo));

      print("İndirme Tamamlandı. Konum: $savePath");
    } catch (e) {
      print("İndirme Hatası: $e");
    } finally {
      isDownloading.set(false);
      await Future.delayed(Duration(seconds: 3));
      GeneralSettingsUtils.setLoading(false);
      await getDownloadedMods();
    }
  }

  Future<void> _extractModData(InAppWebViewController controller) async {
    try {
      var result = await controller.evaluateJavascript(source: _jsScrapingCode);

      if (result != null) {
        title.set(result['title'] ?? "");
        version.set(result['version'] ?? "");
        image.set(result['image_url'] ?? "");
      }
    } catch (e) {
      print(e);
    }
  }
}
