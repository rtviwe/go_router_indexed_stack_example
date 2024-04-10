import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ATab extends StatelessWidget {
  const ATab({super.key, required this.inner});

  final StatefulNavigationShell inner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('A'),
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
              Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: () => inner.goBranch(1),
                  child: const Text('First'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: () => inner.goBranch(2),
                  child: const Text('Second'),
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
