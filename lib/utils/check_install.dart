import 'dart:io';

Future<bool> isModInstalled(String sourceFolderPath) async {
  try {
    String folderName = sourceFolderPath.split(Platform.pathSeparator).last;
    String targetPath = "C:${Platform.pathSeparator}Program Files (x86)${Platform.pathSeparator}Steam${Platform.pathSeparator}steamapps${Platform.pathSeparator}common${Platform.pathSeparator}Stardew Valley${Platform.pathSeparator}Mods${Platform.pathSeparator}$folderName";
    
    Directory modDir = Directory(targetPath);
    
    if (await modDir.exists()) {
      List<FileSystemEntity> entities = await modDir.list().toList();
      return entities.isNotEmpty;
    }
    
    return false;
  } catch (e) {
    return false;
  }
}