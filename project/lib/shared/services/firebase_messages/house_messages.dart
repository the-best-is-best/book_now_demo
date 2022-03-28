import 'dart:developer';

import '../../cubit/floor_states/my_floor_cubit.dart';
import '../../cubit/houses_states/my_house_cubit.dart';

void createHouseMessages() {
  MyHousesCubit cubitHouse = MyHousesCubit.get(MyHousesCubit.context!);
  MyFloorCubit cubitFloor = MyFloorCubit.get(MyHousesCubit.context!);
  cubitHouse
      .getHouses(true)
      .then((_) => cubitFloor.getFloors(cubitHouse.myHouses));
}

void updateHouseMessages(int id) {
  log("id updated : " + id.toString());
  MyHousesCubit cubitHouse = MyHousesCubit.get(MyHousesCubit.context!);
  cubitHouse.getUpdateHouses(id).then((value) {
    MyFloorCubit cubitFloor = MyFloorCubit.get(MyHousesCubit.context!);
    cubitFloor.getFloors(cubitHouse.myHouses);
  });
}
