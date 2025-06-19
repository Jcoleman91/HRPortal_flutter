import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_drawer.dart';

class LinksPage extends StatelessWidget {
  const LinksPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> links = [
      {
        'label': 'ADP Workforce Pay Stub',
        'url': 'https://online.adp.com/signin/v1/?APPID=WFNPortal&productId=80e309c3-7085-bae1-e053-3505430b5495&returnURL=https://workforcenow.adp.com/&callingAppId=WFN',
      },
      {
        'label': 'Payroll Self Service',
        'url': 'http://172.30.5.1/selfservice/',
      },
      {
        'label': 'Wellness Warrior Nomination',
        'url': 'https://fandpwellnesswarrior.questionpro.com/',
      },
      {
        'label': 'Blue Cross Blue Shield',
        'url': 'https://www.anthem.com/?redirected=bcbsga',
      },
      {
        'label': 'Fidelity NetBenefits',
        'url': 'https://nb.fidelity.com/static/mybenefits/netbenefitslogin/#/login',
      },
      {
        'label': 'Infinisource',
        'url': 'https://infinconsumer.lh1ondemand.com/Login.aspx?ReturnUrl=%2f',
      },
      {
        'label': 'Employee Benefits Open Enrollment',
        'url': 'https://mybensite.com/fandpgeorgia/',
      },
      {
        'label': 'MyCigna',
        'url': 'https://my.cigna.com/web/public/guest',
      },
      {
        'label': 'Angioscreen Signup',
        'url': 'https://bit.ly/FandPAngio',
      },
      {
        'label': 'Wellness Trivia',
        'url': 'https://octoberwellnesstrivia.questionpro.com/',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Links"),
        centerTitle: true,
        backgroundColor: const Color(0xFF001F54),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: links.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final link = links[index];
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001F54), // navy
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _launchURL(link['url']!);
              },
              child: Text(
                link['label']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
