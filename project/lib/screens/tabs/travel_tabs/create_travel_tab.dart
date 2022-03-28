import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_style/style/font_style.dart';

import '../../../components/form_field.dart';
import '../../../shared/cubit/travel_states/my_travel_cubit.dart';
import '../../../shared/cubit/travel_states/travel_states.dart';
import '../../../shared/modals/travel_model.dart';

Widget createTravelTab() {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  TextEditingController travelNameController = TextEditingController();

  return Builder(
    builder: (context) {
      final MyTravelCubit cubitTravel = MyTravelCubit.get(context);
      return BlocConsumer<MyTravelCubit, MyTravelsStates>(
        listener: (BuildContext context, MyTravelsStates state) {
          if (state is MyTravelsAddSuccess) {
            travelNameController.text = "";
            BotToast.showText(text: "Added");
          }
        },
        builder: (BuildContext context, MyTravelsStates state) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              "Create Travel",
              style: TBIBFontStyle.h3,
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
                        controller: travelNameController,
                        label: 'Travel Name',
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
                    state is MyTravelsLoadingButton
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            child: Text(
                              "Create",
                              style: TBIBFontStyle.h4,
                            ),
                            onPressed: () async {
                              _keyForm.currentState!.save();
                              if (!_keyForm.currentState!.validate()) {
                                return;
                              }
                              _keyForm.currentState!.save();

                              CreateTravelModel createTravelModel =
                                  CreateTravelModel(
                                name: travelNameController.text,
                              );
                              cubitTravel
                                  .createTravelClicked(createTravelModel);
                            }),
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
