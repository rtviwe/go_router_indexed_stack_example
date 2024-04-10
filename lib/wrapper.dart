import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({super.key, required this.inner});

  final StatefulNavigationShell inner;

  @override
  Widget build(BuildContext context) {
    return inner;
  }
}
