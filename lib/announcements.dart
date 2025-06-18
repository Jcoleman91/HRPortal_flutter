import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'app_drawer.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcements"),
        centerTitle: true,
        backgroundColor: const Color(0xFF001F54),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text("Announcements Content Here"),
      ),
    );
  }
}


