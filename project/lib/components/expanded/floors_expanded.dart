import 'package:book_now_demo/shared/cubit/floor_states/my_floor_cubit.dart';
import 'package:book_now_demo/shared/cubit/rooms_states/rooms_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tbib_style/tbib_style.dart';

import '../../screens/floor_screen.dart';
import '../../screens/rooms/room_screens.dart';
import '../../shared/modals/floors_model.dart';
import '../../shared/modals/houses_model.dart';
import '../../shared/style/main_style.dart';

Widget buildFloorsExpanded(
        {required BuildContext context,
        required HouseModel myHouses,
        required int index}) =>
    Builder(
      builder: (context) {
        final Size query = MediaQuery.of(context).size;
        final MyFloorCubit cubitFloor = MyFloorCubit.get(context);
        MyFloorCubit.context = context;
        final MyRoomsCubit cubitRoom = MyRoomsCubit.get(context);
        MyRoomsCubit.context = context;

        FloorModel floors = cubitFloor.myFloor[index];

        final widthGrid = query.width * 5 / 320;
        final itemRowCount = widthGrid.toInt();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Floors",
                style: TBIBFontStyle.h3,
              ),
            ),
            SizedBox(
              height: spacing5,
            ),
            Divider(
              thickness: spacing3,
            ),
            SizedBox(
              height: spacing5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            duration: const Duration(milliseconds: 500),
                            type: PageTransitionType.fade,
                            child: FloorRoom(
                              myHouse: myHouses,
                            )));
                  },
                  icon: const FaIcon(FontAwesomeIcons.circlePlus),
                ),
              ],
            ),
            SizedBox(
              height: spacing5,
            ),
            Container(
              child: floors.floor[0] > 0
                  ? StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      crossAxisCount: itemRowCount,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: floors.floor.length,
                      itemBuilder: (_, int index) {
                        return ElevatedButton(
                          onPressed: () {
                            cubitRoom
                                .gotToRoom(
                                    house: myHouses.id,
                                    floor: floors.floor[index])
                                .then((_) => Navigator.push(
                                    context,
                                    PageTransition(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        type: PageTransitionType.fade,
                                        child: RoomScreen(
                                          house: myHouses,
                                          floor: floors.floor[index],
                                        ))));
                          },
                          child: Text(
                            floors.floor[index].toString(),
                            style:
                                TBIBFontStyle.h4.copyWith(color: Colors.white),
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
                        "No floors",
                        style: TBIBFontStyle.h4,
                      ),
                    ),
            ),
          ],
        );
      },
    );
