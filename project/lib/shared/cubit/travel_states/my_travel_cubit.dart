import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../components/custom_dialog.dart';
import '../../../screens/tabs/travel_tabs/create_travel_tab.dart';
import '../../../screens/tabs/travel_tabs/select_travel_tab.dart';
import '../../modals/travel_model.dart';
import '../../network/dio_network.dart';
import 'travel_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyTravelCubit extends Cubit<MyTravelsStates> {
  MyTravelCubit() : super(MyTravelsInitialState());

  static MyTravelCubit get(context) => BlocProvider.of(context);
  static BuildContext? context;

  List<TravelModel> myTravel = [];

//get data server
  Future getTravel(bool haveData) async {
    try {
      emit(MyTravelsLoadingData());
      Map<String, dynamic> data = {
        "haveData": haveData ? 1 : 0,
        "count": myTravel.length.toString()
      };
      var response =
          await DioHelper.getData(url: 'get_data/get_travel.php', query: data);
      if (response.statusCode == 201) {
        var datas = response.data['data'];

        // update list
        datas.forEach((data) => myTravel.add(TravelModel.fromJson(data)));
      }
      emit(MyTravelsGetData());
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Get Data Error",
          meesage: " $ex",
          okPressed: () => getTravel(true)).show();
    }
  }

  Future getUpdateTravel(int id) async {
    try {
      Map<String, dynamic> data = {"id": id};

      var response =
          await DioHelper.getData(url: 'get_data/get_travel.php', query: data);
      if (response.statusCode == 201) {
        var datas = response.data['data'];
        TravelModel? travelUpdated;
        datas.forEach((data) async {
          travelUpdated = myTravel.firstWhereOrNull(
            (travel) => travel.id == int.parse(data['id'].toString()),
          );
          if (travelUpdated != null) {
            int index = myTravel.indexOf(travelUpdated!);
            myTravel[index].name = data['name'];
          }
        });
        emit(MyTravelsGetData());
      }
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Get Data Error",
          meesage: " $ex",
          okPressed: () => getUpdateTravel(id)).show();
    }
  }

  Future createTravelClicked(CreateTravelModel createTravelModel) async {
    try {
      emit(MyTravelsLoadingButton());
      var createTravel = createTravelModel.toJson();
      var response = await DioHelper.postData(
        url: "insert_data/create_travel.php",
        query: createTravel,
      );
      var data = response.data;
      if (data['messages'][0] == "Travel Created") {
        await DioHelper.postNotification(data: {"messages": "Travel Created"});
        emit(MyTravelsAddSuccess());
      } else {
        emit(MyTravelsAddFailed());
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
          okPressed: () => createTravelClicked(createTravelModel)).show();
    }
  }

  Future updateTravel({
    required int id,
    required String name,
  }) async {
    try {
      emit(MyTravelsLoadingButton());
      Map<String, dynamic> data = {
        "id": id,
        "name": name,
      };
      var response = await DioHelper.putData(
        url: "update_data/travel_update.php",
        query: data,
      );
      var dataResponse = response.data;
      if (dataResponse['messages'][0] == "Travel updated") {
        DioHelper.postNotification(
            data: {"messages": "Travel Updated", "id": id});
        emit(MyTravelsUpdateSuccess());
      } else {
        emit(MyTravelsUpdateSuccess());
        List<dynamic> messages = dataResponse['messages'];
        for (int i = 0; i < messages.length; i++) {
          BotToast.showText(
            text: messages[i],
            duration: const Duration(seconds: 3),
          );
        }
        emit(MyTravelsUpdateFailed());
      }
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Update Data Error",
          meesage: " $ex",
          okPressed: () => updateTravel(id: id, name: name)).show();
    }
  }

  bool editTravelActive = false;
  void inEdit() {
    editTravelActive = !editTravelActive;
    emit(MyTravelsEdit());
  }

  int tabIndex = 0;
  List<Widget> tabsWidget = [
    createTravelTab(),
    selectTravelTab(),
  ];

  double opacityTab = 1;
  void changeTabIndex(index) async {
    opacityTab = 0;
    emit(MyTravelsChangeTabs());
    await Future.delayed(const Duration(milliseconds: 150)).then((value) {
      tabIndex = index;
      opacityTab = 1;
      emit(MyTravelsChangeTabs());
    });
  }
}
