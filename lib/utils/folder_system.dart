import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:archive/archive_io.dart';
import 'package:stardewmods/utils/general_settings.dart';

class ModFolderManager {
  static const String _boxName = 'virtual_folders';

  static Future<void> createFolder(String folderName) async {
    final box = Hive.box(_boxName);
    if (!box.containsKey(folderName)) {
      await box.put(folderName, []);
    }
  }

  static List<String> getFolderList() {
    final box = Hive.box(_boxName);
    return box.keys.cast<String>().toList();
  }

  static List<Map<String, dynamic>> getModsInFolder(String folderName) {
    final box = Hive.box(_boxName);
    List<dynamic> mods = box.get(folderName, defaultValue: []);
    return mods.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> addModToFolder(
    String folderName,
    Map<String, dynamic> modData,
  ) async {
    final box = Hive.box(_boxName);
    List<dynamic> mods = box.get(folderName, defaultValue: []);

    bool exists = mods.any((m) => m['zip_path'] == modData['zip_path']);
    if (!exists) {
      mods.add(modData);
      await box.put(folderName, mods);
    }
  }

  static Future<void> removeModFromFolder(
    String folderName,
    String zipPath,
  ) async {
    final box = Hive.box(_boxName);
    List<dynamic> mods = box.get(folderName, defaultValue: []);
    mods.removeWhere((m) => m['zip_path'] == zipPath);
    await box.put(folderName, mods);
  }

  static Future<void> renameFolder(String oldName, String newName) async {
    final box = Hive.box(_boxName);
    if (box.containsKey(oldName)) {
      var data = box.get(oldName);
      await box.put(newName, data);
      await box.delete(oldName);
    }
  }

  static Future<void> deleteFolder(String folderName) async {
    final box = Hive.box(_boxName);
    await box.delete(folderName);
  }

  static bool folderExists(String folderName) {
    final box = Hive.box(_boxName);
    return box.containsKey(folderName);
  }

  static Future<void> installAllModsInFolder(
    String folderName,
    Function() onComplete,
    Function(String e) onError,
  ) async {
    try {
      String targetRootPath =
          r"C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Mods";
      Directory modsDir = Directory(targetRootPath);

      if (await modsDir.exists()) {
        final entities = await modsDir.list().toList();
        for (var entity in entities) {
          await entity.delete(recursive: true);
        }
      } else {
        await modsDir.create(recursive: true);
      }

      List<Map<String, dynamic>> mods = getModsInFolder(folderName);

      for (var mod in mods) {
        await installMod(
          mod['folder_path'],
          mod['file_name'],
          () {},
          (e) => throw Exception(e),
        );
      }
      onComplete();
    } catch (e) {
      onError(e.toString());
    }
  }
}

Future<void> installMod(
  String sourceFolderPath,
  String zipFileName,
  Function() onSuccess,
  Function(String e) onError,
) async {
  try {
    GeneralSettingsUtils.setLoading(true);

    final zipPath = "$sourceFolderPath${Platform.pathSeparator}$zipFileName";
    final sourceDir = Directory(sourceFolderPath);

    await extractFileToDisk(zipPath, sourceFolderPath);

    String targetRootPath =
        r"C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Mods";
    String folderName = sourceFolderPath.split(Platform.pathSeparator).last;
    String destinationPath =
        "$targetRootPath${Platform.pathSeparator}$folderName";

    await _copyDirectory(sourceDir, Directory(destinationPath));
    onSuccess();
  } catch (e) {
    onError(e.toString());
  } finally {
    GeneralSettingsUtils.setLoading(false);
  }
}

Future<void> _copyDirectory(Directory source, Directory destination) async {
  await destination.create(recursive: true);
  await for (final entity in source.list(recursive: false)) {
    final newPath =
        destination.path +
        Platform.pathSeparator +
        entity.uri.pathSegments.last;
    if (entity is Directory) {
      await _copyDirectory(entity, Directory(newPath));
    } else if (entity is File) {
      await entity.copy(newPath);
    }
  }
}
