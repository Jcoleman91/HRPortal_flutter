import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_drawer.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> announcements = [
      {
        'label': 'Anthem Notice',
        'url': 'http://172.27.5.15/HRPortal/Downloads/FINALAnthemEdWardMemberNotice.pdf',
      },
      {
        'label': 'Anthem Facts',
        'url': 'https://www.anthemfacts.com/',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcements"),
        centerTitle: true,
        backgroundColor: const Color(0xFF001F54),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: announcements.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = announcements[index];
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001F54),
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _launchURL(item['url']!);
              },
              child: Text(
                item['label']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
