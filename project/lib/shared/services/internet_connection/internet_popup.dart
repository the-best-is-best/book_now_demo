import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:tbib_dialog/tbib_dialog.dart';

import '../../../components/custom_dialog.dart';
import '../alert_google_services.dart';
import '../firebase_services.dart';
import 'check_internet.dart';

class InternetPopup {
  static bool isOnline = true;
  static bool _isDialogOn = false;
  final Connectivity _connectivity = Connectivity();
  static late TBIBDialog _alert;
  static final InternetPopup _internetPopup = InternetPopup._internal();
  factory InternetPopup(BuildContext context) {
    return _internetPopup;
  }

  InternetPopup._internal();

  void initialize({
    required BuildContext context,
    String? customMessage,
    String? customDescription,
    bool? onTapPop = false,
  }) {
    _connectivity.onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        isOnline = await CheckInternet.init();
        await GoogleServesesChecker.init();
        await FirebaseInit.firebaseServices(
            GoogleServesesChecker.getPlaSytoreAvailability,
            CheckInternet.isConnected);
      } else {
        isOnline = false;
        _alert = alertDialog(
          context: context,
          title: 'No Internet',
          meesage: 'Check Your internet Connection',
        );
      }

      if (isOnline == true) {
        if (_isDialogOn == true) {
          _isDialogOn = false;
          _alert.dismiss();
          log("alert closed");
        }
      } else {
        _isDialogOn = true;

        _alert.show();
      }
    });
  }
}
