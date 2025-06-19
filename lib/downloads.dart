import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'app_drawer.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({super.key});

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  final List<Map<String, String>> files = [
    {
      'label': 'Suggestion Form',
      'asset': 'assets/pdfs/SuggestionForm.pdf',
      'url': 'http://172.27.5.15/HRPortal/Downloads/SuggestionForm2.pdf',
      'fileName': 'SuggestionForm.pdf',
    },
    {
      'label': 'Direct Deposit Form',
      'asset': 'assets/pdfs/DirectDepositForm.pdf',
      'url': 'http://172.27.5.15/HRPortal/Downloads/DirectDepositForm.pdf',
      'fileName': 'DirectDepositForm.pdf',
    },
    {
      'label': 'Georgia State Tax Form',
      'asset': 'assets/pdfs/stateTaxForm.pdf',
      'url': 'http://172.27.5.15/HRPortal/Downloads/TSD_Employees_Withholding_Allowance_Certificate_G4.pdf',
      'fileName': 'stateTaxForm.pdf',
    },
    {
      'label': 'Job Transfer Form',
      'asset': 'assets/pdfs/jobTransferForm.pdf',
      'url': 'http://172.27.5.15/HRPortal/Downloads/G4HR008RevBJobTransferForm.pdf',
      'fileName': 'jobTransferForm.pdf',
    },
    {
      'label': 'Accident Claim Form',
      'asset': 'assets/pdfs/AccidentClaimForm.pdf',
      'url': 'http://172.27.5.15/HRPortal/Downloads/AccidentClaimForm67715.pdf',
      'fileName': 'AccidentClaimForm.pdf',
    },
    {
      'label': 'Employee Handbook',
      'asset': 'assets/pdfs/Associate_Handbook.pdf',
      'url': 'http://172.27.5.15/HRPortal/Associate_Handbook_Rev_K_2025.pdf',
      'fileName': 'Associate_Handbook.pdf',
    },
    {
      'label': 'Payroll Change Notice',
      'asset': 'assets/pdfs/PayrollChangeNotice.pdf',
      'url': 'http://172.27.5.15/HRPortal/Downloads/G4HR013RevDPayrollChangeNotice.pdf',
      'fileName': 'PayrollChangeNotice.pdf',
    },
    {
      'label': 'Beneficiary Designation Form',
      'asset': 'assets/pdfs/AnthemBeneficiary.pdf',
      'url': 'http://172.27.5.15/HRPortal/Downloads/AnthemBeneficiary.pdf',
      'fileName': 'AnthemBeneficiary.pdf',
    },
    {
      'label': 'Federal Tax Form',
      'asset': 'assets/pdfs/FederalTaxForm.pdf',
      'url': 'http://172.27.5.15/HRPortal/Downloads/W42014.pdf',
      'fileName': 'FederalTaxForm.pdf',
    },
    {
      'label': 'Wellness Claim Form',
      'asset': 'assets/pdfs/WellnessClaimForm.pdf',
      'url': 'http://172.27.5.15/HRPortal/Downloads/CurrentWellnessClaimForm.pdf',
      'fileName': 'WellnessClaimForm.pdf',
    },
    {
      'label': 'Critical Illness Claim Form',
      'asset': 'assets/pdfs/CriticalIllnessClaimForm.pdf',
      'url': 'http://172.27.5.15/HRPortal/Downloads/CriticalIllnessClaimForm65017.pdf',
      'fileName': 'CriticalIllnessClaimForm.pdf',
    },
  ];

  Future<void> _downloadAndOpenAssetFile(
      BuildContext context, String assetPath, String fileName) async {
    try {
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        if (sdkInt >= 30) {
          final status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Storage permission denied')),
            );
            return;
          }
        } else {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Storage permission denied')),
            );
            return;
          }
        }
      }

      final byteData = await rootBundle.load(assetPath);

      Directory downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
      }

      final file = File('${downloadsDirectory.path}/$fileName');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved to Downloads')),
      );

      await OpenFile.open(file.path);
    } catch (e, stacktrace) {
      print("Error during file save/open: $e");
      print(stacktrace);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download failed')),
      );
    }
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open URL')),
      );
    }
  }

  void _showOptionsDialog(
      BuildContext context, String assetPath, String fileName, String url) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select an Option"),
        content: const Text("Would you like to preview or download this file?"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _launchURL(context, url);
                    },
                    child: const Text("Preview"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _downloadAndOpenAssetFile(context, assetPath, fileName);
                    },
                    child: const Text("Download"),
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
      drawer: const AppDrawer(), // <-- Adds the hamburger menu drawer
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
            onPressed: () => _showOptionsDialog(
              context,
              file['asset']!,
              file['fileName']!,
              file['url']!,
            ),
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
