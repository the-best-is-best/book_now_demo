import 'package:flutter/cupertino.dart';

import 'cubit/floor_states/my_floor_cubit.dart';
import 'cubit/houses_states/my_house_cubit.dart';
import 'cubit/projects_states/my_project_cubit.dart';
import 'cubit/rooms_states/rooms_cubit.dart';
import 'services/internet_connection/internet_popup.dart';

void initPage(BuildContext context) {
  InternetPopup(context).initialize(
    context: context,
  );
  MyProjectCubit.context = context;
  MyHousesCubit.context = context;
  MyRoomsCubit.context = context;
  MyFloorCubit.context = context;
}
