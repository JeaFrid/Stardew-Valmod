import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<void> runSmapiInstaller(
  String url,
  Function() onSuccess,
  Function(String error) onError,
) async {
  try {
    Directory? tempDir = await getDownloadsDirectory();
    tempDir ??= await getApplicationDocumentsDirectory();

    String downloadPath =
        "${tempDir.path}${Platform.pathSeparator}smapi_setup.zip";
    String extractPath =
        "${tempDir.path}${Platform.pathSeparator}smapi_extracted";

    if (await Directory(extractPath).exists()) {
      await Directory(extractPath).delete(recursive: true);
    }

    Dio dio = Dio();
    await dio.download(url, downloadPath);
    await extractFileToDisk(downloadPath, extractPath);

    Directory extractDir = Directory(extractPath);
    List<FileSystemEntity> contents = extractDir.listSync();

    Directory? folderWithSpaces;
    for (var entity in contents) {
      if (entity is Directory) {
        folderWithSpaces = entity;
        break;
      }
    }

    if (folderWithSpaces == null) {
      onError("Zip içinden klasör çıkmadı!");
      return;
    }

    String safeFolderPath = "${extractPath}${Platform.pathSeparator}smapi_root";
    await folderWithSpaces.rename(safeFolderPath);

    String installerExeName = "SMAPI.Installer.exe";
    File? installerFile;

    await for (var entity in Directory(safeFolderPath).list(recursive: true)) {
      if (entity is File && entity.path.endsWith(installerExeName)) {
        installerFile = entity;
        break;
      }
    }

    if (installerFile == null) {
      onError("Installer exe bulunamadı!");
      return;
    }

    String gamePath =
        r"C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley";

    if (!await Directory(gamePath).exists()) {
      onError("Oyun klasörü bulunamadı: $gamePath");
      return;
    }

    var process = await Process.start(
      installerFile.path,
      ['--install', '--game-path', gamePath],
      workingDirectory: installerFile.parent.path,
      runInShell: true,
      mode: ProcessStartMode.detached,
    );

    await Future.delayed(const Duration(seconds: 6));

    await Process.run('taskkill', ['/F', '/T', '/PID', '${process.pid}']);

    onSuccess();
  } catch (e) {
    onError(e.toString());
  }
}