import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/tab_provider.dart';
import '../widgets/browser_webview.dart';
import '../widgets/address_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../services/storage_service.dart';
import '../services/download_service.dart';
import '../models/browser_history.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Uuid _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final tabs = ref.watch(tabProvider);
    final currentIndex = ref.watch(currentTabIndexProvider);
    final currentTab = tabs[currentIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AddressBar(
              currentTab: currentTab,
              onSubmit: (url) {
                currentTab.webController?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
              },
              onRefresh: () {
                currentTab.webController?.reload();
              },
              onStop: () {
                currentTab.webController?.stopLoading();
              },
              onBookmark: () async {
                final isBookmarked = StorageService.isBookmarked(currentTab.url);
                if (isBookmarked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已添加到书签')),
                  );
                  return;
                }
                final bookmark = Bookmark(
                  id: _uuid.v4(),
                  url: currentTab.url,
                  title: currentTab.title,
                  favicon: currentTab.favicon,
                  createTime: DateTime.now(),
                );
                await StorageService.addBookmark(bookmark);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已添加到书签')),
                  );
                }
              },
              onShowTabs: () {
                // 标签页列表弹窗待实现
              },
              onShowMenu: () {
                _showMenu(context);
              },
            ),
            if (currentTab.progress < 1.0)
              LinearProgressIndicator(
                value: currentTab.progress,
                backgroundColor: Colors.transparent,
              ),
            Expanded(
              child: IndexedStack(
                index: currentIndex,
                children: tabs.map((tab) {
                  return BrowserWebView(
                    key: Key(tab.id),
                    tabId: tab.id,
                    initialUrl: tab.url,
                    isIncognito: tab.isIncognito,
                  );
                }).toList(),
              ),
            ),
            BottomNavBar(
              onBack: () async {
                if (await currentTab.webController?.canGoBack() ?? false) {
                  await currentTab.webController?.goBack();
                }
              },
              onForward: () async {
                if (await currentTab.webController?.canGoForward() ?? false) {
                  await currentTab.webController?.goForward();
                }
              },
              onHome: () {
                currentTab.webController?.loadUrl(
                  urlRequest: URLRequest(url: WebUri('https://www.google.com')),
                );
              },
              onShare: () async {
                await launchUrl(Uri.parse('sms:?body=${Uri.encodeComponent(currentTab.url)}'));
              },
              onNewTab: () {
                ref.read(tabProvider.notifier).addNewTab(url: 'https://www.google.com');
                ref.read(currentTabIndexProvider.notifier).state = tabs.length;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('历史记录'),
              onTap: () {
                Navigator.pop(context);
                // 跳转到历史记录页
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('书签'),
              onTap: () {
                Navigator.pop(context);
                // 跳转到书签页
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('下载管理'),
              onTap: () {
                Navigator.pop(context);
                // 跳转到下载页
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('新建隐私标签页'),
              onTap: () {
                Navigator.pop(context);
                ref.read(tabProvider.notifier).addNewTab(
                  url: 'https://www.google.com',
                  isIncognito: true,
                );
                ref.read(currentTabIndexProvider.notifier).state = ref.read(tabProvider).length;
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('设置'),
              onTap: () {
                Navigator.pop(context);
                // 跳转到设置页
              },
            ),
          ],
        );
      },
    );
  }
}
