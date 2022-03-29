import 'package:bot_toast/bot_toast.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/custom_dialog.dart';
import '../../../screens/tabs/people_tabs/create_people_tab.dart';
import '../../../screens/tabs/people_tabs/select_people_tab.dart';
import '../../modals/people_model.dart';
import '../../network/dio_network.dart';
import 'my_people_stares.dart';

class MyPeopleCubit extends Cubit<MyPeopleStates> {
  MyPeopleCubit() : super(MyPeopleInitialState());

  static MyPeopleCubit get(context) => BlocProvider.of(context);
  static BuildContext? context;

  List<PeopleModel> myPeople = [];

  Future getPeople(bool haveData) async {
    try {
      emit(MyPeopleLoadingData());
      Map<String, dynamic> data = {
        "haveData": haveData ? 1 : 0,
        "count": myPeople.length.toString()
      };
      var response =
          await DioHelper.getData(url: 'get_data/get_people.php', query: data);
      if (response.statusCode == 201) {
        var datas = response.data['data'];

        datas.forEach((data) {
          myPeople.add(PeopleModel.fromJson(data));
        });
      }

      emit(MyPeopleGetData());
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Get Data Error",
          meesage: " $ex",
          okPressed: () => getPeople(true)).show();
    }
  }

  Future getUpdatePeople(int id) async {
    try {
      Map<String, dynamic> data = {"id": id};

      var response =
          await DioHelper.getData(url: 'get_data/get_people.php', query: data);
      if (response.statusCode == 201) {
        var datas = response.data['data'];
        // get item has been updated
        PeopleModel? peopleUpdated;
        datas.forEach((data) async {
          peopleUpdated = myPeople.firstWhereOrNull(
              (people) => people.id == int.parse(data['id'].toString()));
          if (peopleUpdated != null) {
            int index = myPeople.indexOf(peopleUpdated!);
            myPeople[index].name = data['name'];
            myPeople[index].tel = "0 ${data['tel']}";
            myPeople[index].city = data['city'];
          }
        });
      }
      emit(MyPeopleGetData());
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Get Data Error",
          meesage: " $ex",
          okPressed: () => getUpdatePeople(id)).show();
    }
  }

  Future createPeopleClicked(CreatePeopleModel createPeopleModel) async {
    try {
      emit(MyPeopleLoadingButton());
      var createPeople = createPeopleModel.toJson();

      var response = await DioHelper.postData(
        url: "insert_data/create_people.php",
        query: createPeople,
      );

      var data = response.data;
      if (data['messages'][0] == "People Created") {
        await DioHelper.postNotification(data: {"messages": "People Created"});
        emit(MyPeopleAddSuccess());
      } else {
        emit(MyPeopleAddFailed());
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
          okPressed: () => createPeopleClicked(createPeopleModel)).show();
    }
  }

  Future updatePeople(
      {required int id,
      required String name,
      required int tel,
      required String city}) async {
    //  try {
    emit(MyPeopleLoadingButton());

    Map<String, dynamic> data = {
      "id": id,
      "name": name,
      "tel": tel,
      "city": city
    };
    var response = await DioHelper.putData(
      url: "update_data/people_update.php",
      query: data,
    );
    var dataResponse = response.data;
    if (dataResponse['messages'][0] == "People updated") {
      DioHelper.postNotification(
          data: {"messages": "People Updated", "id": id});
      emit(MyPeopleUpdateSuccess());
    } else {
      List<dynamic> messages = dataResponse['messages'];
      for (int i = 0; i < messages.length; i++) {
        BotToast.showText(
          text: messages[i],
          duration: const Duration(seconds: 3),
        );
      }
      emit(MyPeopleUpdateFailed());
    }
    /*} catch (ex) {
      alertDialog(
          context: context!,
          title: "Update Data Error",
          meesage: " $ex",
          okPressed: () =>
              updatePeople(id: id, name: name, city: city, tel: tel)).show();
    }*/
  }

  bool loadingSearch = false;
  List<PeopleModel> searchMypeople = [];
  void searchPeople(String search) {
    loadingSearch = true;
    emit(MyPeopleSearch());
    if (search != "") {
      searchMypeople =
          myPeople.where((people) => people.name.contains(search)).toList();
    }
    loadingSearch = false;
    emit(MyPeopleGetData());
  }

  bool editRoomActive = false;
  void inEdit() {
    editRoomActive = !editRoomActive;
    emit(MyPeopleEdit());
  }

  int tabIndex = 0;
  List<Widget> tabsWidget = [
    createPeopleTab(),
    selectPeopleTab(),
  ];
  double opacityTab = 1;
  void changeTabIndex(index) async {
    opacityTab = 0;
    emit(MyPeopleChangeTabs());
    await Future.delayed(const Duration(milliseconds: 150)).then((value) {
      tabIndex = index;
      opacityTab = 1;
      emit(MyPeopleChangeTabs());
    });
  }
}
