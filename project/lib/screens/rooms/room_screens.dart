import 'package:book_now_demo/shared/cubit/rooms_states/rooms_cubit.dart';
import 'package:book_now_demo/shared/cubit/rooms_states/rooms_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/init_page.dart';
import '../../shared/modals/houses_model.dart';
import '../../shared/services/internet_connection/internet_popup.dart';
import '../../shared/style/main_style.dart';

class RoomScreen extends StatefulWidget {
  final HouseModel house;
  final int floor;

  const RoomScreen({required this.house, required this.floor, Key? key})
      : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  void initState() {
    initPage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final MyRoomsCubit cubitRoom = MyRoomsCubit.get(context);
      MyRoomsCubit.context = context;
      return BlocConsumer<MyRoomsCubit, MyRoomsStates>(
        listener: (BuildContext context, MyRoomsStates state) {
          if (state is MyRoomsAddSuccess) {
          } else if (state is MyRoomsAddFailed) {}
        },
        builder: (BuildContext context, MyRoomsStates state) => Scaffold(
          appBar: AppBar(
              title: Text(
                  "Rooms for - ${widget.house.name} - floor: ${widget.floor} ")),
          body: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: cubitRoom.tabIndex == 0
                    ? MediaQuery.of(context).size.width / 1.1
                    : null,
                child: Card(
                  elevation: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: cubitRoom.tabsWidget[cubitRoom.tabIndex],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 20,
            onTap: (val) {
              cubitRoom.changeTabIndex(val);
            },
            currentIndex: cubitRoom.tabIndex,
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
    });
  }
}
