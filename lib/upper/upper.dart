import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:indexed_stack/router.dart';

class UpperTab extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        Future.delayed(const Duration(seconds: 3), () {
          final config = myConfig;
          config.updateBranches(['1', '2'], ['1', '2']);
        });
        return () {};
      },
      const [],
    );

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
