import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tbib_style/style/font_style.dart';

import '../util/device_screen.dart';

void fontsServices() {
  if (DeviceType.isLargeScreen()) {
    TBIBFontStyle.h4 = TBIBFontStyle.h4.copyWith(fontWeight: FontWeight.w400);
    TBIBFontStyle.h3 = TBIBFontStyle.h3.copyWith(fontWeight: FontWeight.w600);
  }
  TBIBFontStyle.addCustomFont("Helvetica", null);
  log(TBIBFontStyle.h4.fontSize.toString());
}
