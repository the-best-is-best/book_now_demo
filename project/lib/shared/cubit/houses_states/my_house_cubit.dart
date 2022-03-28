import 'package:book_now_demo/shared/cubit/houses_states/my_houses_states.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/custom_dialog.dart';
import '../../../screens/tabs/create_select_houes/create_house_tab.dart';
import '../../../screens/tabs/create_select_houes/select_house_tab.dart';
import '../../modals/houses_model.dart';
import '../../network/dio_network.dart';

class MyHousesCubit extends Cubit<MyHousesStates> {
  MyHousesCubit() : super(MyHousesInitialState());
  static MyHousesCubit get(context) => BlocProvider.of(context);

  static BuildContext? context;

  List<HouseModel> myHouses = [];
  List<HouseModel> searchMyHouse = [];
  int tabIndex = 0;
  List<Widget> tabsWidget = [
    createHouseTab(),
    selectHousesTab(),
  ];

//get data server
  Future getHouses(bool haveData) async {
    emit(MyHousesLoadingData());

    Map<String, dynamic> data = {
      "haveData": haveData ? 1 : 0,
      "count": myHouses.length.toString()
    };
    try {
      var response =
          await DioHelper.getData(url: 'get_data/get_houses.php', query: data);
      if (response.statusCode == 201) {
        var datas = response.data['data'];

        // update list
        datas.forEach((data) => myHouses.add(HouseModel.fromJson(data)));
      }
      emit(MyHousesGetData());
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Get Data Error",
          meesage: " $ex",
          okPressed: () => getHouses(true)).show();
    }
  }

  Future getUpdateHouses(int id) async {
    try {
      emit(MyHousesLoadingData());

      Map<String, dynamic> data = {"id": id};

      var response =
          await DioHelper.getData(url: 'get_data/get_houses.php', query: data);
      if (response.statusCode == 201) {
        var datas = response.data['data'];
        HouseModel? houseUpdated;
        datas.forEach((data) async {
          houseUpdated = myHouses.firstWhereOrNull(
              (house) => house.id == int.parse(data['id'].toString()));
          if (houseUpdated != null) {
            int index = myHouses.indexOf(houseUpdated!);
            myHouses[index].floor = int.parse(data['floor'].toString());
          }
        });
      }
      emit(MyHousesGetData());
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Get Data Error",
          meesage: " $ex",
          okPressed: () => getUpdateHouses(id)).show();
    }
  }

  Future createHouseClicked(CreateHouseModel createHouseModel) async {
    try {
      emit(MyHousesLoadingButton());
      var createHouse = createHouseModel.toJson();
      var response = await DioHelper.postData(
        url: "insert_data/create_houses.php",
        query: createHouse,
      );

      var data = response.data;
      if (data['messages'][0] == "House Created") {
        await DioHelper.postNotification(data: {"messages": "House Created"});
        emit(MyHousesAddSuccess());
      } else {
        emit(MyHousesAddFailed());
      }
      List<dynamic> messages = data['messages'];
      for (int i = 0; i < messages.length; i++) {
        BotToast.showText(
          text: messages[i],
          duration: const Duration(seconds: 3),
        );
      }
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Create Data Error",
          meesage: " $ex",
          okPressed: () => createHouseClicked(createHouseModel)).show();
    }
  }

  Future updateFloor(int id, int floor) async {
    try {
      emit(MyHousesLoadingButton());
      Map<String, int> query = {
        "id": id,
        "floor": floor,
      };
      var response = await DioHelper.putData(
        url: "update_data/floors_update.php",
        query: query,
      );

      var data = response.data;
      if (data['messages'][0] == "Floor updated") {
        DioHelper.postNotification(
            data: {"messages": "Floor Updated", "id": id});
        emit(MyHousesUpdateSuccess());
      } else {
        emit(MyHousesUpdateSuccess());
        List<dynamic> messages = data['messages'];
        for (int i = 0; i < messages.length; i++) {
          BotToast.showText(
            text: messages[i],
            duration: const Duration(seconds: 3),
          );
        }
        emit(MyHousesUpdateFailed());
      }
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Update Data Error",
          meesage: " $ex",
          okPressed: () => updateFloor(id, floor)).show();
    }
  }

  bool loadingSearch = false;

  void searchHouse(String search) {
    loadingSearch = true;
    emit(MyHousesSearch());
    if (search != "") {
      searchMyHouse =
          myHouses.where((house) => house.name.contains(search)).toList();
    }
    loadingSearch = false;

    emit(MyHousesGetData());
  }

  void changeTabIndex(index) {
    tabIndex = index;
    emit(MyHousesChangeTabs());
  }
}
