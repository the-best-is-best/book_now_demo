import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/custom_dialog.dart';
import '../../../screens/tabs/rooms_tabs/create_room_tab.dart';
import '../../../screens/tabs/rooms_tabs/select_room_tab.dart';
import '../../modals/rooms_model.dart';
import '../../network/dio_network.dart';
import 'rooms_states.dart';

class MyRoomsCubit extends Cubit<MyRoomsStates> {
  MyRoomsCubit() : super(MyRoomsInitialState());

  static MyRoomsCubit get(context) => BlocProvider.of(context);
  static BuildContext? context;

  late int curHouse;
  late int curFloor;

  List<RoomsModel> myRooms = [];

  Future getRooms() async {
    try {
      myRooms = [];
      emit(MyRoomsLoadingData());
      Map<String, dynamic> data = {};

      var response =
          await DioHelper.getData(url: 'get_data/get_rooms.php', query: data);
      if (response.statusCode == 201) {
        var datas = response.data['data'];

        datas.forEach((data) {
          myRooms.add(RoomsModel.fromJson(data));
        });
      }
      emit(MyRoomsGetData());
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Get Data Error",
          meesage: " $ex",
          okPressed: () => getRooms()).show();
    }
  }

  Future getUpdateRoom(int id) async {
    try {
      emit(MyRoomsLoadingData());

      Map<String, dynamic> data = {"id": id};

      var response =
          await DioHelper.getData(url: 'get_data/get_rooms.php', query: data);
      if (response.statusCode == 201) {
        var datas = response.data['data'];

        datas.forEach((data) {
          RoomsModel? roomUpdated;
          roomUpdated =
              myRooms.firstWhereOrNull((room) => room.id == data['id']);

          if (roomUpdated != null) {
            int index = myRooms.indexOf(roomUpdated);
            myRooms[index].numbersOfBed = data['numbers_of_bed'];
            myRooms[index].bunkBed = data['bunk_bed'];
          }
        });
      }

      emit(MyRoomsGetData());
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Get Data Error",
          meesage: " $ex",
          okPressed: () => getUpdateRoom(id)).show();
    }
  }

  Future gotToRoom({required int house, required int floor}) async {
    curHouse = house;
    curFloor = floor;
  }

  Future createRoomClicked(CreateRoomModel createRoomModel) async {
    try {
      emit(MyRoomsLoadingButton());
      var createRoom = createRoomModel.toJson();

      var response = await DioHelper.postData(
        url: "insert_data/create_room.php",
        query: createRoom,
      );
      var data = response.data;
      if (data['messages'][0] == "Room Created") {
        DioHelper.postNotification(data: {"messages": "Room Created"});
        emit(MyRoomsAddSuccess());
      } else {
        List<dynamic> messages = data['messages'];
        for (int i = 0; i < messages.length; i++) {
          BotToast.showText(
            text: messages[i],
            duration: const Duration(seconds: 3),
          );
        }
        emit(MyRoomsAddFailed());
      }
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Create Data Error",
          meesage: " $ex",
          okPressed: () => createRoomClicked(createRoomModel)).show();
    }
  }

  void complatedAdd() {
    DioHelper.postNotification(data: {"messages": "Room Created"});
  }

  Future updateRoom(AddBunkBed addBunkBed) async {
    try {
      emit(MyRoomsLoadingButton());
      var data = addBunkBed.toJson();
      var response = await DioHelper.putData(
        url: "update_data/room_update.php",
        query: data,
      );
      var dataResponse = response.data;
      if (dataResponse['messages'][0] == "Room updated") {
        await DioHelper.postNotification(
            data: {"messages": "Room Updated", "id": addBunkBed.id});

        emit(MyRoomsUpdateSuccess());
      } else {
        List<dynamic> messages = dataResponse['messages'];
        for (int i = 0; i < messages.length; i++) {
          BotToast.showText(
            text: messages[i],
            duration: const Duration(seconds: 3),
          );

          emit(MyRoomsUpdateFailed());
        }
      }
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Update Data Error",
          meesage: " $ex",
          okPressed: () => updateRoom(addBunkBed)).show();
    }
  }

  bool editRoomActive = false;
  void inEdit() {
    editRoomActive = !editRoomActive;
    emit(MyRoomsEdit());
  }

  int tabIndex = 0;
  List<Widget> tabsWidget = [
    createRoomTab(),
    selectRoomTab(),
  ];
  void changeTabIndex(index) {
    tabIndex = index;
    emit(MyHousesChangeTabs());
  }
}
