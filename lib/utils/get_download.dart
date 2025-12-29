import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

Future<List<Map<String, dynamic>>> getAllDownloadedMods() async {
  List<Map<String, dynamic>> modList = [];

  try {
    Directory? baseDir = await getDownloadsDirectory();
    baseDir ??= await getApplicationDocumentsDirectory();

    final mainModDir = Directory(
      "${baseDir.path}${Platform.pathSeparator}StardewValmod",
    );

    if (!await mainModDir.exists()) {
      return [];
    }

    List<FileSystemEntity> entities = await mainModDir.list().toList();

    for (var entity in entities) {
      if (entity is Directory) {
        try {
          List<FileSystemEntity> filesInModDir = await entity.list().toList();

          File? jsonFile;
          try {
            jsonFile =
                filesInModDir.firstWhere((file) => file.path.endsWith('.json'))
                    as File;
          } catch (_) {
            continue;
          }

          String content = await jsonFile.readAsString();
          Map<String, dynamic> jsonData = jsonDecode(content);

          String fileName = jsonData['file_name'] ?? "";
          String zipFullPath =
              "${entity.path}${Platform.pathSeparator}$fileName";

          if (await File(zipFullPath).exists()) {
            modList.add({
              "title": jsonData['title'],
              "version": jsonData['version'],
              "image_url": jsonData['image_url'],
              "zip_path": zipFullPath,
              "folder_path": entity.path,
              "file_name": fileName,
              "downloaded_at": jsonData['downloaded_at'],
            });
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  return modList;
}

Future<void> removeDownloadedModFiles(
  String sourceFolderPath,
  String zipFileName,
  Function() onSuccess,
  Function(String e) onError,
) async {
  try {
    Directory targetDir = Directory(sourceFolderPath);

    if (await targetDir.exists()) {
      await targetDir.delete(recursive: true);
      onSuccess();
    } else {
      onError("Silinecek klasör bulunamadı.");
    }
  } catch (e) {
    onError(e.toString());
  }
}
