import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final Function() onBack;
  final Function() onForward;
  final Function() onHome;
  final Function() onShare;
  final Function() onNewTab;

  const BottomNavBar({
    super.key,
    required this.onBack,
    required this.onForward,
    required this.onHome,
    required this.onShare,
    required this.onNewTab,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 56,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
            tooltip: '后退',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: onForward,
            tooltip: '前进',
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: onHome,
            tooltip: '主页',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: onShare,
            tooltip: '分享',
          ),
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: onNewTab,
            tooltip: '新建标签页',
          ),
        ],
      ),
    );
  }
}
