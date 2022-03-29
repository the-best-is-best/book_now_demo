import 'package:book_now_demo/shared/cubit/houses_states/my_house_cubit.dart';
import 'package:book_now_demo/shared/cubit/houses_states/my_houses_states.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/app_bar_component.dart';
import '../components/build_menu.dart';
import '../shared/init_page.dart';
import '../shared/style/main_style.dart';

class HousesScreen extends StatefulWidget {
  const HousesScreen({Key? key}) : super(key: key);

  @override
  _HousesScreenState createState() => _HousesScreenState();
}

class _HousesScreenState extends State<HousesScreen> {
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
      openRatio: .75,
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
      drawer: buildMenu(1, context, _advancedDrawerController),
      child: Builder(builder: (context) {
        final MyHousesCubit cubitHouse = MyHousesCubit.get(context);
        MyHousesCubit.context = context;
        return BlocConsumer<MyHousesCubit, MyHousesStates>(
          listener: (BuildContext context, MyHousesStates state) {
            if (state is MyHousesAddSuccess) {
            } else if (state is MyHousesAddFailed) {}
          },
          builder: (BuildContext context, MyHousesStates state) => Scaffold(
            appBar: buildAppBar("Houses", _advancedDrawerController),
            body: DoubleBackToCloseApp(
              snackBar: const SnackBar(
                content: Text('Tap back again to leave'),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: cubitHouse.tabIndex == 0
                        ? MediaQuery.of(context).size.width / 1.1
                        : null,
                    child: Card(
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: AnimatedOpacity(
                            opacity: cubitHouse.opacityTab,
                            duration: const Duration(milliseconds: 125),
                            child: cubitHouse.tabsWidget[cubitHouse.tabIndex]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 20,
              onTap: (val) {
                cubitHouse.changeTabIndex(val);
              },
              currentIndex: cubitHouse.tabIndex,
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
