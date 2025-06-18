import 'package:flutter/material.dart';
import 'app_drawer.dart';

class LinksPage extends StatelessWidget {
  const LinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Links"),
        centerTitle: true,
        backgroundColor: const Color(0xFF001F54),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text("Links Content Here"),
      ),
    );
  }
}
