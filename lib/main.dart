import 'package:flutter/material.dart';
import 'announcements.dart';
import 'links.dart';
import 'downloads.dart';
import 'app_drawer.dart';

void main() {
  runApp(const HRPortalApp());
}

class HRPortalApp extends StatelessWidget {
  const HRPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF001F54),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF001F54),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 280,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/fppicture.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "HR Portal",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              buildNavButton(context, "ANNOUNCEMENTS"),
              buildNavButton(context, "LINKS"),
              buildNavButton(context, "DOWNLOADS"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavButton(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF001F54),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16, letterSpacing: 1.5),
          ),
          onPressed: () {
            Widget page;
            switch (label.toUpperCase()) {
              case 'ANNOUNCEMENTS':
                page = const AnnouncementsPage();
                break;
              case 'LINKS':
                page = const LinksPage();
                break;
              case 'DOWNLOADS':
                page = const DownloadsPage();
                break;
              default:
                return;
            }

            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, animation, __) => page,
                transitionsBuilder: (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}