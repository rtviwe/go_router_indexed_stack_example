import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpperTab extends StatelessWidget {
  const UpperTab({
    super.key,
    required this.inner,
    required this.parentPath,
    required this.tabContent,
  });

  final StatefulNavigationShell inner;
  final String parentPath;
  final List<String> tabContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Upper $parentPath'),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: () => inner.goBranch(0),
                  child: const Text('Close'),
                ),
              ),
              for (final content in tabContent.indexed)
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: ElevatedButton(
                    onPressed: () => inner.goBranch(content.$1 + 1),
                    child: Text(content.$2),
                  ),
                ),
            ],
          ),
          SizedBox(
            width: 600,
            height: 600,
            child: inner,
          ),
        ],
      ),
    );
  }
}
