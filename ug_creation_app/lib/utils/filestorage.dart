import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';

class FileStorage {
  Future<String> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
    }
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> requestPermissions(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
