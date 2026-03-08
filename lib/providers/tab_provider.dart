import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/tab_model.dart';

final tabProvider = StateNotifierProvider<TabNotifier, List<TabModel>>((ref) {
  return TabNotifier();
});

final currentTabIndexProvider = StateProvider<int>((ref) => 0);

class TabNotifier extends StateNotifier<List<TabModel>> {
  TabNotifier() : super([]) {
    addNewTab(url: 'https://www.google.com');
  }

  final Uuid _uuid = const Uuid();

  void addNewTab({required String url, bool isIncognito = false}) {
    final newTab = TabModel(
      id: _uuid.v4(),
      url: url,
      isIncognito: isIncognito,
    );
    state = [...state, newTab];
  }

  void closeTab(String id) {
    if (state.length <= 1) return;
    
    final index = state.indexWhere((tab) => tab.id == id);
    state = state.where((tab) => tab.id != id).toList();
  }

  void updateTab(String id, {String? url, String? title, String? favicon, double? progress, bool? isLoading, InAppWebViewController? webController}) {
    state = state.map((tab) {
      if (tab.id == id) {
        return tab.copyWith(
          url: url,
          title: title,
          favicon: favicon,
          progress: progress,
          isLoading: isLoading,
          webController: webController,
        );
      }
      return tab;
    }).toList();
  }

  void closeAllTabs() {
    state = [];
    addNewTab(url: 'https://www.google.com');
  }

  void closeIncognitoTabs() {
    state = state.where((tab) => !tab.isIncognito).toList();
    if (state.isEmpty) {
      addNewTab(url: 'https://www.google.com');
    }
  }
}
