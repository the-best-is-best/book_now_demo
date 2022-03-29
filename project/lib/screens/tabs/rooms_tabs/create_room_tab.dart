import 'package:book_now_demo/shared/cubit/rooms_states/rooms_cubit.dart';
import 'package:book_now_demo/shared/cubit/rooms_states/rooms_states.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_style/tbib_style.dart';

import '../../../components/form_field.dart';
import '../../../shared/modals/rooms_model.dart';
import '../../../shared/style/main_style.dart';

Widget createRoomTab() {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  final curRoomController = TextEditingController();
  final lastRoomController = TextEditingController();
  final numOfBedController = TextEditingController();

  return Builder(
    builder: (context) {
      final MyRoomsCubit cubitRoom = MyRoomsCubit.get(context);
      MyRoomsCubit.context = context;
      final houseId = cubitRoom.curHouse;
      final floor = cubitRoom.curFloor;
      return BlocConsumer<MyRoomsCubit, MyRoomsStates>(
        listener: (BuildContext context, MyRoomsStates state) {
          if (state is MyRoomsAddSuccess) {
            curRoomController.text =
                lastRoomController.text = numOfBedController.text = "";
            BotToast.showText(text: "Added");
          } else if (state is MyRoomsAddFailed) {}
        },
        builder: (BuildContext context, MyRoomsStates state) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              "Create Room",
              style: TBIBFontStyle.h3,
            )),
            SizedBox(
              height: spacing5,
            ),
            Divider(
              thickness: spacing3,
            ),
            SizedBox(
              height: spacing15,
            ),
            Center(
              child: Form(
                key: _keyForm,
                child: Column(
                  children: [
                    defaultFormField(
                        context: context,
                        controller: curRoomController,
                        label: 'First Room Number',
                        type: TextInputType.number,
                        validate: (String? val) {
                          if (val == null || val.isEmpty) {
                            return "Empty !!";
                          }
                          int? convertToInt = int.tryParse(val);
                          if (convertToInt == null) {
                            return "Number not valid";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: spacing15,
                    ),
                    defaultFormField(
                        context: context,
                        controller: lastRoomController,
                        label: 'Last Room Number',
                        type: TextInputType.number,
                        validate: (String? val) {
                          if (val == null || val.isEmpty) {
                            lastRoomController.text = val = 0.toString();
                            return null;
                          }
                          int? convertToInt = int.tryParse(val);
                          if (convertToInt == null) {
                            return "Number not valid";
                          }
                          int last = int.parse(val);
                          int cur = int.parse(curRoomController.text);
                          if (last != 0 && last < cur) {
                            return "Last is less than number of room please + ${last - cur}";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: spacing15,
                    ),
                    defaultFormField(
                        context: context,
                        controller: numOfBedController,
                        label: 'Number of bed',
                        type: TextInputType.number,
                        validate: (String? val) {
                          if (val == null || val.isEmpty) {
                            return "Empty !!";
                          }
                          int? convertToInt = int.tryParse(val);
                          if (convertToInt == null) {
                            return "Number not valid";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: spacing15,
                    ),
                    state is MyRoomsLoadingButton
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            child: Text(
                              "Create",
                              style: TBIBFontStyle.h4
                                  .copyWith(color: Colors.white),
                            ),
                            onPressed: () {
                              _keyForm.currentState!.save();
                              if (!_keyForm.currentState!.validate()) {
                                return;
                              }
                              _keyForm.currentState!.save();
                              List<int> rooms = [];
                              int last = int.parse(lastRoomController.text);
                              int cur = int.parse(curRoomController.text);
                              if (last == 0 || last == cur) {
                                CreateRoomModel createRoomModel =
                                    CreateRoomModel(
                                        houseId: houseId,
                                        name: cur.toString(),
                                        floor: floor,
                                        numbersOfBed:
                                            int.parse(numOfBedController.text));

                                cubitRoom.createRoomClicked(createRoomModel);
                                cubitRoom.complatedAdd();
                              } else {
                                for (int i = cur; i <= last; i++) {
                                  rooms.add(i);
                                }
                                for (int i = 0; i < rooms.length; i++) {
                                  CreateRoomModel createRoomModel =
                                      CreateRoomModel(
                                          houseId: houseId,
                                          name: rooms[i].toString(),
                                          floor: floor,
                                          numbersOfBed: int.parse(
                                              numOfBedController.text));

                                  cubitRoom.createRoomClicked(createRoomModel);
                                }
                                cubitRoom.complatedAdd();
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: spacing20,
            )
          ],
        ),
      );
    },
  );
}
