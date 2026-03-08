import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tab_provider.dart';
import '../services/ad_block_service.dart';
import '../services/storage_service.dart';
import '../models/browser_history.dart';
import 'package:uuid/uuid.dart';

class BrowserWebView extends ConsumerStatefulWidget {
  final String tabId;
  final String initialUrl;
  final bool isIncognito;

  const BrowserWebView({
    super.key,
    required this.tabId,
    required this.initialUrl,
    required this.isIncognito,
  });

  @override
  ConsumerState<BrowserWebView> createState() => _BrowserWebViewState();
}

class _BrowserWebViewState extends ConsumerState<BrowserWebView> {
  InAppWebViewController? _webViewController;
  final Uuid _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
      initialSettings: InAppWebViewSettings(
        useShouldInterceptRequest: true,
        javaScriptEnabled: true,
        domStorageEnabled: !widget.isIncognito,
        cacheEnabled: !widget.isIncognito,
        incognito: widget.isIncognito,
        useWideViewPort: true,
        loadWithOverviewMode: true,
        supportZoom: true,
        builtInZoomControls: true,
        displayZoomControls: false,
        allowsBackForwardNavigationGestures: true,
      ),
      onWebViewCreated: (controller) {
        _webViewController = controller;
        ref.read(tabProvider.notifier).updateTab(
          widget.tabId,
          webController: controller,
        );
      },
      shouldInterceptRequest: AdBlockService.shouldInterceptRequest,
      onLoadStart: (controller, url) {
        if (url != null) {
          ref.read(tabProvider.notifier).updateTab(
            widget.tabId,
            url: url.toString(),
            isLoading: true,
            progress: 0.0,
          );
        }
      },
      onLoadStop: (controller, url) async {
        if (url != null) {
          final title = await controller.getTitle();
          final favicons = await controller.getFavicons();
          String? favicon;
          if (favicons.isNotEmpty) {
            favicon = favicons.first.url.toString();
          }

          ref.read(tabProvider.notifier).updateTab(
            widget.tabId,
            title: title ?? '',
            favicon: favicon,
            isLoading: false,
            progress: 1.0,
          );

          if (!widget.isIncognito && url.toString().startsWith('http')) {
            final history = BrowserHistory(
              id: _uuid.v4(),
              url: url.toString(),
              title: title ?? '',
              favicon: favicon,
              visitTime: DateTime.now(),
            );
            await StorageService.addHistory(history);
          }
        }
      },
      onProgressChanged: (controller, progress) {
        ref.read(tabProvider.notifier).updateTab(
          widget.tabId,
          progress: progress / 100,
        );
      },
      onDownloadStartRequest: (controller, downloadStartRequest) async {
        // 下载功能待实现
        return null;
      },
    );
  }
}
