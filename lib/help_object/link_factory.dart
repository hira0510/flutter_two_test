import 'package:url_launcher/url_launcher.dart';

class LinkFactory {
  LinkFactory._();

  static Future<void> launchUrl(String? url) async {
    if (url != null && url != "") {
      await launch(url, forceSafariVC: false);
    }
  }
}