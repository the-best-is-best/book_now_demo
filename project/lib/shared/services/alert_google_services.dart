import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/services.dart';
import 'package:google_api_availability/google_api_availability.dart';

class GoogleServesesChecker {
  static GooglePlayServicesAvailability getPlaSytoreAvailability =
      GooglePlayServicesAvailability.unknown;

  static Future init() async {
    try {
      getPlaSytoreAvailability = await GoogleApiAvailability.instance
          .checkGooglePlayServicesAvailability();
    } on PlatformException {
      getPlaSytoreAvailability = GooglePlayServicesAvailability.unknown;
    }
    getPlaSytoreAvailability = GooglePlayServicesAvailability.success;
  }

  static void alertGoogleServices() async {
    // Platform messages may fail, so we use a try/catch PlatformException.

    if (getPlaSytoreAvailability != GooglePlayServicesAvailability.success) {
      BotToast.showText(
          text: getPlaSytoreAvailability.toString(),
          duration: const Duration(seconds: 5));
    }
  }
}
