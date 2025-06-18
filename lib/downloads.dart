import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  final List<Map<String, String>> files = [
    {
      'label': 'Suggestion Form',
      'url': 'http://172.27.5.15/HRPortal/Downloads/SuggestionForm2.pdf',
      'fileName': 'SuggestionForm.pdf',
    },
    {
      'label': 'Direct Deposit Form',
      'url': 'http://172.27.5.15/HRPortal/Downloads/DirectDepositForm.pdf',
      'fileName': 'DirectDepositForm.pdf',
    },
    // Add other PDFs similarly
  ];

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open URL')));
    }
  }

  Future<void> _downloadAndOpenFile(String url, String fileName) async {
    try {
      // Request storage permission (only needed for Android)
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Storage permission denied')));
          return;
        }
      }

      // Get downloads directory (Android), fallback to app documents directory
      Directory downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
      }

      final filePath = '${downloadsDirectory.path}/$fileName';

      // Download file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download file');
      }

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Saved to Downloads')));

      // Open file
      await OpenFile.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Download failed')));
    }
  }

  void _showOptionsDialog(String url, String fileName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select an Option"),
        content: const Text("Would you like to preview or download this file?"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel button on the far left
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              // Preview and Download buttons on the right
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _downloadAndOpenFile(url, fileName);
                    },
                    child: const Text("Download"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _launchURL(url);
                    },
                    child: const Text("Preview"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        centerTitle: true,
        backgroundColor: const Color(0xFF001F54),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: files.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final file = files[index];
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF001F54),
              minimumSize: const Size.fromHeight(60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _showOptionsDialog(file['url']!, file['fileName']!),
            child: Text(
              file['label']!,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }
}
