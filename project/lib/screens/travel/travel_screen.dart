import 'package:book_now_demo/shared/cubit/travel_states/my_travel_cubit.dart';
import 'package:book_now_demo/shared/cubit/travel_states/travel_states.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../components/app_bar_component.dart';
import '../../components/build_menu.dart';
import '../../shared/init_page.dart';
import '../../shared/style/main_style.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({Key? key}) : super(key: key);

  @override
  _TravelScreenState createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
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
    final MyTravelCubit cubitTravel = MyTravelCubit.get(context);
    return BlocConsumer<MyTravelCubit, MyTravelsStates>(
      listener: (BuildContext context, MyTravelsStates state) {},
      builder: (BuildContext context, MyTravelsStates state) => AdvancedDrawer(
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
        drawer: buildMenu(3, context, _advancedDrawerController),
        child: Scaffold(
          appBar: buildAppBar("Travel", _advancedDrawerController),
          body: Center(
            child: DoubleBackToCloseApp(
              snackBar: const SnackBar(
                content: Text('Tap back again to leave'),
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: cubitTravel.tabIndex == 0
                      ? MediaQuery.of(context).size.width / 1.1
                      : null,
                  child: Card(
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AnimatedOpacity(
                          opacity: cubitTravel.opacityTab,
                          duration: const Duration(milliseconds: 125),
                          child: cubitTravel.tabsWidget[cubitTravel.tabIndex]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 20,
            onTap: (val) {
              cubitTravel.changeTabIndex(val);
            },
            currentIndex: cubitTravel.tabIndex,
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
