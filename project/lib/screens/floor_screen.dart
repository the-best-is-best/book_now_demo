import 'package:book_now_demo/shared/cubit/houses_states/my_house_cubit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_style/tbib_style.dart';

import '../components/form_field.dart';
import '../shared/cubit/houses_states/my_houses_states.dart';
import '../shared/init_page.dart';
import '../shared/modals/houses_model.dart';

class FloorRoom extends StatefulWidget {
  final HouseModel myHouse;

  const FloorRoom({required this.myHouse, Key? key}) : super(key: key);

  @override
  State<FloorRoom> createState() => _FloorRoomState();
}

class _FloorRoomState extends State<FloorRoom> {
  @override
  void initState() {
    initPage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MyHousesCubit myHousesCubit = MyHousesCubit.get(context);
    final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
    final TextEditingController newFloorNamberController =
        TextEditingController();

    return BlocConsumer<MyHousesCubit, MyHousesStates>(
      listener: (BuildContext context, MyHousesStates state) {
        if (state is MyHousesUpdateSuccess) {
          BotToast.showText(text: "Upadated");
        } else if (state is MyHousesUpdateFailed) {}
      },
      builder: (BuildContext context, MyHousesStates state) => Scaffold(
        appBar: AppBar(
          title: Text("Create Floor - ${widget.myHouse.name}"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                      "Add Floor",
                      style: TBIBFontStyle.h2,
                    )),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      thickness: 3,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Form(
                        key: _keyForm,
                        child: Column(
                          children: [
                            defaultFormField(
                                context: context,
                                controller: newFloorNamberController,
                                label: 'Add new floors',
                                type: TextInputType.number,
                                validate: (String? val) {
                                  if (val == null || val.isEmpty) {
                                    return "empty !!";
                                  }
                                  int? convertToInt = int.tryParse(val);
                                  if (convertToInt == null) {
                                    return "Number not valid";
                                  }
                                  return null;
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            state is MyHousesLoadingButton
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    child: Text(
                                      "Add",
                                      style: TBIBFontStyle.h4
                                          .copyWith(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      _keyForm.currentState!.save();
                                      if (!_keyForm.currentState!.validate()) {
                                        return;
                                      }
                                      _keyForm.currentState!.save();

                                      myHousesCubit.updateFloor(
                                          widget.myHouse.id,
                                          int.parse(
                                              newFloorNamberController.text));
                                    },
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
