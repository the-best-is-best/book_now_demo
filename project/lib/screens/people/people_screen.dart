import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/app_bar_component.dart';
import '../../components/build_menu.dart';
import '../../shared/cubit/people_states/my_people_cubit.dart';
import '../../shared/cubit/people_states/my_people_stares.dart';
import '../../shared/init_page.dart';
import '../../shared/style/main_style.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
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
    final MyPeopleCubit myPeopleCubit = MyPeopleCubit.get(context);

    return BlocConsumer<MyPeopleCubit, MyPeopleStates>(
      listener: (BuildContext context, MyPeopleStates state) {},
      builder: (BuildContext context, MyPeopleStates state) => AdvancedDrawer(
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
        drawer: buildMenu(2, context, _advancedDrawerController),
        child: Scaffold(
          appBar: buildAppBar("People", _advancedDrawerController),
          body: Center(
            child: DoubleBackToCloseApp(
              snackBar: const SnackBar(
                content: Text('Tap back again to leave'),
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: myPeopleCubit.tabIndex == 0
                      ? MediaQuery.of(context).size.width / 1.1
                      : null,
                  child: Card(
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AnimatedOpacity(
                          opacity: myPeopleCubit.opacityTab,
                          duration: const Duration(milliseconds: 125),
                          child:
                              myPeopleCubit.tabsWidget[myPeopleCubit.tabIndex]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 20,
            onTap: (val) {
              myPeopleCubit.changeTabIndex(val);
            },
            currentIndex: myPeopleCubit.tabIndex,
            unselectedFontSize: 15,
            type: BottomNavigationBarType.fixed,
            backgroundColor: mainColor,
            fixedColor: Colors.black,
            unselectedItemColor: Colors.brown,
            // ignore: prefer_const_literals_to_create_immutables
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.create),
                label: 'Create',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.select_all),
                label: 'Select',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
