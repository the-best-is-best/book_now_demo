import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/custom_dialog.dart';

import '../../../screens/tabs/project_tab/create_project_tab.dart';
import '../../../screens/tabs/project_tab/select_project_tab.dart';
import '../../modals/project_model.dart';
import '../../network/dio_network.dart';
import 'my_projects_states.dart';

class MyProjectCubit extends Cubit<MyProjectsStates> {
  MyProjectCubit() : super(MyProjectsInitialState());

  static MyProjectCubit get(context) => BlocProvider.of(context);
  static BuildContext? context;
  List<ProjectsModel> myProject = [];

  Future<dynamic> getData(bool haveData) async {
    try {
      emit(MyProjectsLoadingData());

      Map<String, dynamic> data = {
        "haveData": haveData ? 1 : 0,
        "count": myProject.length.toString()
      };
      var response = await DioHelper.getData(
          url: 'get_data/get_projects.php', query: data);

      if (response.statusCode == 201) {
        var datas = response.data['data'];
        int? projectId;
        datas.forEach((data) {
          myProject.add(ProjectsModel.fromJson(data));
        });
        for (var data in myProject) {
          if (data.endDate.isAfter(DateTime.now())) {
            projectId = data.id;
          }
        }
        if (projectId != null) {
          return projectId;
        } else {
          return null;
        }
      }
      emit(MyProjectsGetData());
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Get Data Error",
          meesage: " $ex",
          okPressed: () => getData(true)).show();
    }
  }

  Future createProjectClicked(CreateProjectModel crateProjectsModel) async {
    try {
      emit(MyProjectsLoadingButton());
      var createProject = crateProjectsModel.toJson();

      var response = await DioHelper.postData(
        url: "insert_data/create_project.php",
        query: createProject,
      );

      var data = response.data;
      if (data['messages'][0] == "Project Created") {
        await DioHelper.postNotification(data: {"messages": "Project Created"});
        emit(MyProjectsAddSuccess());
      } else {
        emit(MyProjectsAddFailed());
        List<dynamic> messages = data['messages'];
        for (int i = 0; i < messages.length; i++) {
          BotToast.showText(
            text: messages[i],
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (ex) {
      alertDialog(
          context: context!,
          title: "Create Data Error",
          meesage: " $ex",
          okPressed: () => createProjectClicked(crateProjectsModel)).show();
    }
  }

  int tabIndex = 0;
  List<Widget> tabsWidget = [
    createProjectTab(),
    selectProjectTab(),
  ];
  double opacityTab = 1;
  void changeTabIndex(index) async {
    opacityTab = 0;
    emit(MyProjectsChangeTabs());
    await Future.delayed(const Duration(milliseconds: 150)).then((value) {
      tabIndex = index;
      opacityTab = 1;
      emit(MyProjectsChangeTabs());
    });
  }

  int? houseSelected;
  void changeHouseSelected(val) {
    houseSelected = val;

    emit(MyProjectsChangeHouseSelected());
  }
}
