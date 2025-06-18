import 'package:flutter/material.dart';
import '../announcements.dart';
import '../links.dart';
import '../downloads.dart';
import '../main.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 160,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fppicture.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _buildDrawerItem(context, Icons.home, 'Home', const HomePage()),
            _buildDrawerItem(context, Icons.announcement, 'Announcements', const AnnouncementsPage()),
            _buildDrawerItem(context, Icons.link, 'Links', const LinksPage()),
            _buildDrawerItem(context, Icons.download, 'Downloads', const DownloadsPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String label, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(label),
      onTap: () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => page,
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
    );
  }
}
