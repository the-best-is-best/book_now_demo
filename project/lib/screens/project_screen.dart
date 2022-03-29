import 'package:book_now_demo/shared/cubit/projects_states/my_project_cubit.dart';
import 'package:book_now_demo/shared/cubit/projects_states/my_projects_states.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/app_bar_component.dart';
import '../components/build_menu.dart';
import '../shared/init_page.dart';
import '../shared/style/main_style.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  @override
  void initState() {
    initPage(context);
    super.initState();
  }

  @override
  void dispose() {
    _advancedDrawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.blueGrey,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: buildMenu(0, context, _advancedDrawerController),
      child: Builder(builder: (context) {
        final MyProjectCubit cubitProject = MyProjectCubit.get(context);
        MyProjectCubit.context = context;

        return BlocConsumer<MyProjectCubit, MyProjectsStates>(
          listener: (BuildContext context, MyProjectsStates state) {
            if (state is MyProjectsAddSuccess) {
            } else if (state is MyProjectsAddFailed) {}
          },
          builder: (BuildContext context, MyProjectsStates state) => Scaffold(
            appBar: buildAppBar("My Project", _advancedDrawerController),
            body: DoubleBackToCloseApp(
              snackBar: const SnackBar(
                content: Text('Tap back again to leave'),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: cubitProject.tabIndex == 0
                        ? MediaQuery.of(context).size.width / 1.1
                        : null,
                    child: Card(
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: AnimatedOpacity(
                            opacity: cubitProject.opacityTab,
                            duration: const Duration(milliseconds: 125),
                            child:
                                cubitProject.tabsWidget[cubitProject.tabIndex]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 20,
              onTap: (val) {
                cubitProject.changeTabIndex(val);
              },
              currentIndex: cubitProject.tabIndex,
              unselectedFontSize: 15,
              type: BottomNavigationBarType.fixed,
              backgroundColor: mainColor,
              fixedColor: Colors.black,
              unselectedItemColor: Colors.brown,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.create),
                  label: 'Create',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.select_all),
                  label: 'Select',
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
