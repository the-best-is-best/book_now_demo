import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tbib_style/style/font_style.dart';

import '../../screens/house_screen.dart';
import '../../screens/people/people_screen.dart';
import '../screens/project_screen.dart';
import '../screens/travel/travel_screen.dart';
import '../shared/style/main_style.dart';

Widget buildMenu(int curPage, BuildContext context,
    AdvancedDrawerController drawerController) {
  return SafeArea(
    child: ListTileTheme(
      textColor: Colors.white,
      iconColor: Colors.white,
      selectedColor: mainColor,
      selectedTileColor: Colors.black54,
      horizontalTitleGap: spacing20,
      contentPadding:
          EdgeInsets.symmetric(vertical: spacing15, horizontal: spacing20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            selected: curPage == 0 ? true : false,
            onTap: curPage == 0
                ? null
                : () async {
                    drawerController.hideDrawer();
                    await Future.delayed(const Duration(milliseconds: 290))
                        .then(
                      (value) => Navigator.pushReplacement(
                        context,
                        PageTransition(
                          duration: const Duration(milliseconds: 500),
                          type: PageTransitionType.fade,
                          child: const ProjectScreen(),
                        ),
                      ),
                    );
                  },
            leading: FaIcon(
              FontAwesomeIcons.diagramProject,
              size: iconTileSize,
            ),
            title: Text(
              'My Project',
              style: TextStyle(fontSize: tileFontSize),
            ),
          ),
          ListTile(
            selected: curPage == 1 ? true : false,
            onTap: curPage == 1
                ? null
                : () async {
                    drawerController.hideDrawer();
                    await Future.delayed(const Duration(milliseconds: 290))
                        .then(
                      (value) => Navigator.pushReplacement(
                        context,
                        PageTransition(
                          duration: const Duration(milliseconds: 500),
                          type: PageTransitionType.fade,
                          child: const HousesScreen(),
                        ),
                      ),
                    );
                  },
            leading: FaIcon(
              FontAwesomeIcons.houseUser,
              size: iconTileSize,
            ),
            title: Text(
              'Houses',
              style: TextStyle(fontSize: tileFontSize),
            ),
          ),
          ListTile(
            selected: curPage == 2 ? true : false,
            onTap: curPage == 2
                ? null
                : () async {
                    drawerController.hideDrawer();
                    await Future.delayed(const Duration(milliseconds: 290));
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            duration: const Duration(milliseconds: 500),
                            type: PageTransitionType.fade,
                            child: const PeopleScreen()));
                  },
            leading: Icon(
              Icons.people_alt,
              size: iconTileSize,
            ),
            title: Text(
              'People',
              style: TextStyle(fontSize: tileFontSize),
            ),
          ),
          ListTile(
            selected: curPage == 3 ? true : false,
            onTap: curPage == 3
                ? null
                : () async {
                    drawerController.hideDrawer();
                    await Future.delayed(const Duration(milliseconds: 290));
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            duration: const Duration(milliseconds: 500),
                            type: PageTransitionType.fade,
                            child: const TravelScreen()));
                  },
            leading: Icon(
              Icons.travel_explore,
              size: iconTileSize,
            ),
            title: Text(
              'Travel',
              style: TextStyle(fontSize: tileFontSize),
            ),
          ),
          /*
          ListTile(
            selected: curPage == 4 ? true : false,
            onTap: curPage == 4
                ? null
                : () {
                    checkData.getMaxPage();
                    checkData.getDataPage(1);

                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            duration: Duration(milliseconds: 500),
                            type: PageTransitionType.fade,
                            child: HistoryScreen()));
                  },
            leading: Icon(Icons.history),
            title: Text('History'),
          ),*/
        ],
      ),
    ),
  );
}
