import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LowerTab extends StatelessWidget {
  const LowerTab({super.key, required this.inner});

  final StatefulNavigationShell inner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('lower'),
          ),
          SizedBox(
            width: 300,
            height: 300,
            child: inner,
          ),
        ],
      ),
    );
  }
}
