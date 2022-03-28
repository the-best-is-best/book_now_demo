import 'package:book_now_demo/shared/cubit/houses_states/my_house_cubit.dart';
import 'package:book_now_demo/shared/cubit/houses_states/my_houses_states.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_style/tbib_style.dart';

import '../../../components/form_field.dart';
import '../../../shared/modals/houses_model.dart';

Widget createHouseTab() {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  TextEditingController houseNameController = TextEditingController();
  TextEditingController floorNamberController = TextEditingController();

  return Builder(
    builder: (context) {
      final MyHousesCubit cubitHouse = MyHousesCubit.get(context);
      MyHousesCubit.context = context;
      return BlocConsumer<MyHousesCubit, MyHousesStates>(
        listener: (BuildContext context, MyHousesStates state) {
          if (state is MyHousesAddSuccess) {
            houseNameController.text = floorNamberController.text = "";
            BotToast.showText(text: "Added");
          } else if (state is MyHousesAddFailed) {}
        },
        builder: (BuildContext context, MyHousesStates state) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              "Create Houses",
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
                        controller: houseNameController,
                        label: 'House Name *',
                        type: TextInputType.text,
                        validate: (String? val) {
                          if (val == null || val.isEmpty || val.length < 3) {
                            return "min 3 characters";
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    defaultFormField(
                        context: context,
                        controller: floorNamberController,
                        label: 'Total floors *',
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
                    state is! MyHousesLoadingButton
                        ? ElevatedButton(
                            child: Text(
                              "Create",
                              style: TBIBFontStyle.h4Dark,
                            ),
                            onPressed: () async {
                              if (!_keyForm.currentState!.validate()) {
                                return;
                              }
                              _keyForm.currentState!.save();

                              CreateHouseModel createHouseModel =
                                  CreateHouseModel(
                                name: houseNameController.text,
                                floor: int.parse(
                                  floorNamberController.text,
                                ),
                              );
                              cubitHouse.createHouseClicked(createHouseModel);
                            },
                          )
                        : const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      );
    },
  );
}
