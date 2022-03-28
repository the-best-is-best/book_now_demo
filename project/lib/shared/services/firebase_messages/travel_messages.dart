import 'dart:developer';

import '../../cubit/travel_states/my_travel_cubit.dart';

void createTravelMessages() {
  MyTravelCubit cubitTravel = MyTravelCubit.get(MyTravelCubit.context!);
  cubitTravel.getTravel(true);
}

void updateTravelMessages(int id) {
  log("id updated : " + id.toString());
  MyTravelCubit cubitTravel = MyTravelCubit.get(MyTravelCubit.context!);
  cubitTravel.getUpdateTravel(id);
}
