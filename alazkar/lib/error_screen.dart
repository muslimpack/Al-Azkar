// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/constants/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorScreen extends StatelessWidget {
  final FlutterErrorDetails details;
  const ErrorScreen({
    super.key,
    required this.details,
  });

  Future<void> _sendEmail(BuildContext context, String errorMessage) async {
    final String subject = 'الأذكار النووية | خلل في الأداء | $appVersion';
    final String body = 'حدث الخطأ التالي:\n\n$errorMessage\n\n';
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: kDeveloperEmail,
      query: Uri.encodeFull(
        'subject=$subject&body=$body',
      ),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح تطبيق البريد'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ رسالة الخطأ'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = details.exceptionAsString();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 80),
              const Text(
                'حدث خطأ ما!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(context, errorMessage),
                    icon: const Icon(Icons.copy),
                    label: const Text('نسخ رسالة الخطأ'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _sendEmail(context, errorMessage),
                    icon: const Icon(Icons.email),
                    label: const Text('إرسال إلى المطوّر'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
