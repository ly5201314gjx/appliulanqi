import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tab_provider.dart';
import '../models/tab_model.dart';

class AddressBar extends ConsumerWidget {
  final TabModel currentTab;
  final Function(String) onSubmit;
  final Function() onRefresh;
  final Function() onStop;
  final Function() onBookmark;
  final Function() onShowTabs;
  final Function() onShowMenu;

  const AddressBar({
    super.key,
    required this.currentTab,
    required this.onSubmit,
    required this.onRefresh,
    required this.onStop,
    required this.onBookmark,
    required this.onShowTabs,
    required this.onShowMenu,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: currentTab.url),
              onSubmitted: (value) {
                if (value.isEmpty) return;
                String url = value;
                if (!url.startsWith('http')) {
                  if (url.contains('.') && !url.contains(' ')) {
                    url = 'https://$url';
                  } else {
                    url = 'https://www.google.com/search?q=${Uri.encodeComponent(url)}';
                  }
                }
                onSubmit(url);
              },
              decoration: InputDecoration(
                hintText: '搜索或输入网址',
                prefixIcon: currentTab.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                isDense: true,
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.go,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\n')),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(currentTab.isLoading ? Icons.close : Icons.refresh, size: 24),
            onPressed: currentTab.isLoading ? onStop : onRefresh,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, size: 24),
            onPressed: onBookmark,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
          IconButton(
            icon: const Icon(Icons.tab, size: 24),
            onPressed: onShowTabs,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 24),
            onPressed: onShowMenu,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }
}
