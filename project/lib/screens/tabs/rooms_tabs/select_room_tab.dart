import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tbib_style/style/font_style.dart';

import '../../../shared/cubit/rooms_states/rooms_cubit.dart';
import '../../../shared/cubit/rooms_states/rooms_states.dart';
import '../../../shared/modals/rooms_model.dart';
import '../../../shared/style/main_style.dart';
import '../../rooms/room_details_screen.dart';

Widget selectRoomTab() {
  return Column(
    children: [
      Builder(builder: (context) {
        final query = MediaQuery.of(context).size;
        final widthGrid = query.width * 5 / 320;
        final itemRowCount = widthGrid.toInt();

        final MyRoomsCubit cubitRoom = MyRoomsCubit.get(context);
        MyRoomsCubit.context = context;
        final houseId = cubitRoom.curHouse;
        final floor = cubitRoom.curFloor;

        final List<RoomsModel> curRoomes = cubitRoom.myRooms
            .where((room) => room.houseId == houseId && room.floor == floor)
            .toList();

        return BlocConsumer<MyRoomsCubit, MyRoomsStates>(
          listener: (BuildContext context, MyRoomsStates state) {},
          builder: (BuildContext context, MyRoomsStates state) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text(
                "Select Room",
                style: TBIBFontStyle.h2,
              )),
              SizedBox(
                height: spacing5,
              ),
              Divider(
                thickness: spacing3,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SizedBox(
                    width: query.width,
                    child: curRoomes.isNotEmpty
                        ? StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            crossAxisCount: itemRowCount,
                            itemCount: curRoomes.length,
                            itemBuilder: (_, int index) {
                              return ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          type: PageTransitionType.fade,
                                          child: RoomDetailsScreen(
                                            room: curRoomes[index],
                                          )));
                                },
                                child: Text(
                                  curRoomes[index].name.toString(),
                                  style: TBIBFontStyle.h4
                                      .copyWith(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                ),
                              );
                            },
                            staggeredTileBuilder: (int index) =>
                                const StaggeredTile.count(1, 1),
                            mainAxisSpacing: 5.0,
                            crossAxisSpacing: 5.0,
                          )
                        : Center(
                            child: Text(
                              "No Rooms",
                              style: TBIBFontStyle.h4,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    ],
  );
}
