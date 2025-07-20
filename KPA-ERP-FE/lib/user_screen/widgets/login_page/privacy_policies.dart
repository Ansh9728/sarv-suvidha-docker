import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(String urlString) async {
  final url = Uri.parse(urlString);
  try {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $urlString';
    }
  } catch (error) {
    print(error);
  }
}

Widget privacyPolicyRender(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      _launchUrl('https://railops.biputri.com/privacy-policy');
                    },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
            width: 20,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Term & Condition",
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      _launchUrl('https://railops.biputri.com/terms-conditions');
                    },
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 15),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Know about this app",
              style: const TextStyle(
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchUrl('https://suvidhaen.com/sanchalak');
                },
            ),
          ],
        ),
      ),
    ],
  );
}
