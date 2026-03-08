import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/browser_history.dart';

class StorageService {
  static late Box historyBox;
  static late Box bookmarkBox;
  static late Box settingsBox;

  static Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    
    historyBox = await Hive.openBox('history');
    bookmarkBox = await Hive.openBox('bookmarks');
    settingsBox = await Hive.openBox('settings');
  }

  static Future<void> addHistory(BrowserHistory history) async {
    await historyBox.put(history.id, history.toMap());
  }

  static List<BrowserHistory> getHistory() {
    return historyBox.values.map((e) => BrowserHistory.fromMap(Map<String, dynamic>.from(e))).toList()
      ..sort((a, b) => b.visitTime.compareTo(a.visitTime));
  }

  static Future<void> deleteHistory(String id) async {
    await historyBox.delete(id);
  }

  static Future<void> clearHistory() async {
    await historyBox.clear();
  }

  static Future<void> addBookmark(Bookmark bookmark) async {
    await bookmarkBox.put(bookmark.id, bookmark.toMap());
  }

  static List<Bookmark> getBookmarks() {
    return bookmarkBox.values.map((e) => Bookmark.fromMap(Map<String, dynamic>.from(e))).toList()
      ..sort((a, b) => b.createTime.compareTo(a.createTime));
  }

  static bool isBookmarked(String url) {
    return bookmarkBox.values.any((e) => Bookmark.fromMap(Map<String, dynamic>.from(e)).url == url);
  }

  static Future<void> deleteBookmark(String id) async {
    await bookmarkBox.delete(id);
  }

  static Future<void> saveSetting(String key, dynamic value) async {
    await settingsBox.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue);
  }
}
