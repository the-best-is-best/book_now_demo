import 'package:book_now_demo/screens/project_screen.dart';
import 'package:book_now_demo/shared/cubit/people_states/my_people_cubit.dart';
import 'package:book_now_demo/shared/cubit/projects_states/my_project_cubit.dart';
import 'package:book_now_demo/shared/cubit/rooms_states/rooms_cubit.dart';
import 'package:book_now_demo/shared/cubit/travel_states/my_travel_cubit.dart';
import 'package:book_now_demo/shared/init_page.dart';
import 'package:flutter/material.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';
import 'package:tbib_style/tbib_style.dart';

import '../shared/cubit/floor_states/my_floor_cubit.dart';
import '../shared/cubit/houses_states/my_house_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoaded = false;
  @override
  void initState() {
    MyProjectCubit cubitProject = MyProjectCubit.get(context);

    cubitProject.getData(false);
    MyHousesCubit cubitHouse = MyHousesCubit.get(context);
    MyFloorCubit cubitFloor = MyFloorCubit.get(context);
    cubitHouse
        .getHouses(false)
        .then((_) => cubitFloor.getFloors(cubitHouse.myHouses));

    MyRoomsCubit myRoomsCubit = MyRoomsCubit.get(context);
    myRoomsCubit.getRooms();

    MyPeopleCubit cubitPeople = MyPeopleCubit.get(context);
    cubitPeople.getPeople(false);

    MyTravelCubit cubitTravel = MyTravelCubit.get(context);
    cubitTravel.getTravel(false);

    setState(() {
      isLoaded = true;
    });
    super.initState();
    initPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateWhere: isLoaded,
      paddingText: const EdgeInsets.only(top: 100),
      text: ScaleAnimatedSplashScreenText(
        "Loading ...",
        duration: const Duration(seconds: 1),
        textStyle: TBIBFontStyle.h3,
      ),
      navigateRoute: const ProjectScreen(),
      imageSrc: "assets/images/logo.png",
      logoSize: 240,
    );
  }
}
