import 'package:flutter/material.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Text('url: $url'),
    );
  }
}
