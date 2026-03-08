import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  static Future<void> init() async {
    await FlutterDownloader.initialize(debug: false);
  }

  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.request();
      final notificationStatus = await Permission.notification.request();
      return storageStatus.isGranted && notificationStatus.isGranted;
    }
    return true;
  }

  static Future<String?> downloadFile(String url, String fileName) async {
    final hasPermission = await requestPermissions();
    if (!hasPermission) return null;

    final Directory? externalDir = await getExternalStorageDirectory();
    if (externalDir == null) return null;
    
    final downloadsDir = Directory('${externalDir.path}/Download');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: downloadsDir.path,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: true,
    );

    return taskId;
  }

  static Future<void> cancelDownload(String taskId) async {
    await FlutterDownloader.cancel(taskId: taskId);
  }

  static Future<void> pauseDownload(String taskId) async {
    await FlutterDownloader.pause(taskId: taskId);
  }

  static Future<void> resumeDownload(String taskId) async {
    await FlutterDownloader.resume(taskId: taskId);
  }
}
