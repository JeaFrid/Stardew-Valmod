import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:stardewmods/utils/general_settings.dart';

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
    print(e);
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

Future<void> deleteMod(
  String zipFileName,
  Function() onSuccess,
  Function(String e) onError,
) async {
  try {
    String folderName = zipFileName.replaceAll(RegExp(r'\.(zip|rar|7z)$'), '');
    
    String targetPath = "C:${Platform.pathSeparator}Program Files (x86)${Platform.pathSeparator}Steam${Platform.pathSeparator}steamapps${Platform.pathSeparator}common${Platform.pathSeparator}Stardew Valley${Platform.pathSeparator}Mods${Platform.pathSeparator}$folderName";

    Directory modDir = Directory(targetPath);

    if (await modDir.exists()) {
      await modDir.delete(recursive: true);
      onSuccess();
    } else {
      onError("Mod klasörü bulunamadı.");
    }
  } catch (e) {
    onError(e.toString());
  }
}