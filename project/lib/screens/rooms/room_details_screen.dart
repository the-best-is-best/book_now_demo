import 'package:book_now_demo/shared/cubit/houses_states/my_house_cubit.dart';
import 'package:book_now_demo/shared/cubit/rooms_states/rooms_cubit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbib_style/style/font_style.dart';

import '../../components/form_field.dart';
import '../../shared/cubit/rooms_states/rooms_states.dart';
import '../../shared/init_page.dart';
import '../../shared/modals/rooms_model.dart';

class RoomDetailsScreen extends StatefulWidget {
  final RoomsModel room;

  const RoomDetailsScreen({required this.room, Key? key}) : super(key: key);

  @override
  _RoomDetailsScreenState createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  final _keyForm = GlobalKey<FormState>();
  final newNumOfBedController = TextEditingController();
  final newNumOfBunkBedController = TextEditingController();

  bool firstload = false;
  @override
  void initState() {
    initPage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MyHousesCubit cubitHouse = MyHousesCubit.get(context);
    MyHousesCubit.context = context;
    MyRoomsCubit cubitRoom = MyRoomsCubit.get(context);
    MyRoomsCubit.context = context;
    final myHouse = cubitHouse.myHouses
        .firstWhere((house) => house.id == widget.room.houseId);
    if (!firstload) {
      newNumOfBedController.text = widget.room.numbersOfBed.toString();
      newNumOfBunkBedController.text = widget.room.bunkBed.toString();
      firstload = true;
    }
    return BlocConsumer<MyRoomsCubit, MyRoomsStates>(
      listener: (BuildContext context, MyRoomsStates state) {
        if (state is MyRoomsUpdateSuccess) {
          BotToast.showText(text: "Updated");
        } else if (state is MyRoomsUpdateFailed) {}
      },
      builder: (BuildContext context, MyRoomsStates state) => Scaffold(
        appBar: AppBar(
          title: Text(
              "H: ${myHouse.name} - F: ${widget.room.floor} R:  ${widget.room.name}"),
          actions: [
            IconButton(
              icon: cubitRoom.editRoomActive
                  ? const FaIcon(FontAwesomeIcons.eye)
                  : const FaIcon(FontAwesomeIcons.penToSquare),
              onPressed: () {
                cubitRoom.inEdit();
              },
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Card(
                  elevation: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        cubitRoom.editRoomActive
                            ? Column(
                                children: [
                                  Form(
                                    key: _keyForm,
                                    child: Column(
                                      children: [
                                        defaultFormField(
                                            context: context,
                                            controller: newNumOfBedController,
                                            label: 'New number of bed',
                                            type: TextInputType.number,
                                            validate: (String? val) {
                                              if (val == null || val.isEmpty) {
                                                return 'empty !!';
                                              }
                                              int? convertToInt =
                                                  int.tryParse(val);
                                              if (convertToInt == null) {
                                                return "Number not valid";
                                              }
                                              return null;
                                            }),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        defaultFormField(
                                            context: context,
                                            controller:
                                                newNumOfBunkBedController,
                                            label: 'New bunk bed',
                                            type: TextInputType.number,
                                            validate: (String? val) {
                                              if (val == null || val.isEmpty) {
                                                newNumOfBunkBedController.text =
                                                    val = 0.toString();
                                                return null;
                                              }
                                              int? convertToInt =
                                                  int.tryParse(val);
                                              if (convertToInt == null) {
                                                return "Number not valid";
                                              }
                                              if (int.parse(val) * 2 >
                                                  int.parse(
                                                      newNumOfBedController
                                                          .text)) {
                                                return "Number of Bunk Bed issues";
                                              }
                                              return null;
                                            }),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  state is MyRoomsLoadingButton
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                          child: Text(
                                            "Edit",
                                            style: TBIBFontStyle.h4
                                                .copyWith(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            _keyForm.currentState!.save();
                                            if (!_keyForm.currentState!
                                                .validate()) {
                                              return;
                                            }
                                            _keyForm.currentState!.save();

                                            cubitRoom.updateRoom(
                                              AddBunkBed(
                                                  id: widget.room.id,
                                                  bunkBed: int.parse(
                                                      newNumOfBunkBedController
                                                          .text),
                                                  numbersOfBed: int.parse(
                                                      newNumOfBedController
                                                          .text)),
                                            );
                                          }),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    "Number of bed : ${widget.room.numbersOfBed}",
                                    style: TBIBFontStyle.h4,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Number of Bunk Bed : ${widget.room.bunkBed}",
                                    style: TBIBFontStyle.h4,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Divider(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Singe bed : ${widget.room.numbersOfBed - (widget.room.bunkBed * 2)}",
                                    style: TBIBFontStyle.h4,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Bunk bed : ${(widget.room.bunkBed)} - (*2) ",
                                    style: TBIBFontStyle.h4,
                                  ),
                                ],
                              ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
