import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modals/floors_model.dart';
import '../../modals/houses_model.dart';
import 'my_floor_states.dart';

class MyFloorCubit extends Cubit<MyFloorStates> {
  MyFloorCubit() : super(MyFloorInitialState());
  static MyFloorCubit get(context) => BlocProvider.of(context);

  static BuildContext? context;

  List<FloorModel> myFloor = [];

  Future getFloors(List<HouseModel> myHouses) async {
    myFloor = [];

    for (var house in myHouses) {
      List<int> floors = [];
      if (house.floor > 0) {
        for (int i = 0; i < house.floor; i++) {
          floors.add(i + 1);
        }
      } else {
        floors.add(0);
      }
      myFloor.add(FloorModel(houseId: house.id, floor: floors));
    }
    emit(MyLoadedInitialState());
  }
}
