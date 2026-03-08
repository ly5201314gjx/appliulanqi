import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TabModel {
  final String id;
  String url;
  String title;
  String? favicon;
  bool isIncognito;
  InAppWebViewController? webController;
  double progress;
  bool isLoading;

  TabModel({
    required this.id,
    required this.url,
    this.title = '',
    this.favicon,
    this.isIncognito = false,
    this.webController,
    this.progress = 0.0,
    this.isLoading = false,
  });

  TabModel copyWith({
    String? id,
    String? url,
    String? title,
    String? favicon,
    bool? isIncognito,
    InAppWebViewController? webController,
    double? progress,
    bool? isLoading,
  }) {
    return TabModel(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      favicon: favicon ?? this.favicon,
      isIncognito: isIncognito ?? this.isIncognito,
      webController: webController ?? this.webController,
      progress: progress ?? this.progress,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
