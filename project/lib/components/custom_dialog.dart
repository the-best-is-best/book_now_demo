import 'package:flutter/material.dart';
import 'package:tbib_dialog/tbib_dialog.dart';
import 'package:tbib_style/tbib_style.dart';

TBIBDialog alertDialog({
  required BuildContext context,
  required String title,
  required String meesage,
  IconData iconHeader = Icons.info_outlined,
  Function? okPressed,
  bool multiplayer = false,
}) {
  return TBIBDialog(
    context: context,
    animType: AnimType.SCALE,
    dialogBackgroundColor: const Color.fromARGB(255, 126, 47, 35),
    dismissOnBackKeyPress: false,
    dismissOnTouchOutside: false,
    body: Center(
      child: SizedBox(
        height: 150,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Text(
              title,
              style: TBIBFontStyle.h3Dark,
              textAlign: TextAlign.center,
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Text(
              meesage,
              style: TBIBFontStyle.h4Dark,
              textAlign: TextAlign.center,
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ],
        ),
      ),
    ),
    btnOkOnPress: okPressed,
    title: title,
    desc: meesage,
  );
}
