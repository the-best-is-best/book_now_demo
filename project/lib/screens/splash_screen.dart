import 'package:book_now_demo/screens/project_screen.dart';
import 'package:book_now_demo/shared/cubit/projects_states/my_project_cubit.dart';
import 'package:book_now_demo/shared/cubit/rooms_states/rooms_cubit.dart';
import 'package:flutter/material.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';
import 'package:tbib_style/tbib_style.dart';

import '../shared/cubit/floor_states/my_floor_cubit.dart';
import '../shared/cubit/houses_states/my_house_cubit.dart';
import '../shared/init_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoaded = false;
  @override
  void initState() {
    initPage(context);
    MyProjectCubit cubitProject = MyProjectCubit.get(context);

    cubitProject.getData(false);
    MyHousesCubit cubitHouse = MyHousesCubit.get(context);
    MyFloorCubit cubitFloor = MyFloorCubit.get(context);
    cubitHouse
        .getHouses(false)
        .then((_) => cubitFloor.getFloors(cubitHouse.myHouses));

    MyRoomsCubit myRoomsCubit = MyRoomsCubit.get(context);
    myRoomsCubit.getRooms();

    setState(() {
      isLoaded = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateWhere: isLoaded,
      paddingText: EdgeInsets.only(top: 40),
      text: ScaleAnimatedSplashScreenText(
        "Loading ...",
        duration: const Duration(seconds: 1),
        textStyle: TBIBFontStyle.h3,
      ),
      navigateRoute: const ProjectScreen(),
      imageSrc: "assets/images/logo.png",
      logoSize: 360,
    );
  }
}
