import 'package:book_now_demo/shared/cubit/people_states/my_people_cubit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_style/style/font_style.dart';

import '../../../components/form_field.dart';
import '../../../shared/cubit/people_states/my_people_stares.dart';
import '../../../shared/modals/people_model.dart';
import '../../../shared/style/main_style.dart';

Widget createPeopleTab() {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  TextEditingController peopleNameController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  return Builder(
    builder: (context) {
      final MyPeopleCubit myPeopleCubit = MyPeopleCubit.get(context);
      return BlocConsumer<MyPeopleCubit, MyPeopleStates>(
        listener: (BuildContext context, MyPeopleStates state) {
          if (state is MyPeopleAddSuccess) {
            peopleNameController.text =
                telController.text = cityController.text = "";
            BotToast.showText(text: "Added");
          } else if (state is MyPeopleAddFailed) {}
        },
        builder: (BuildContext context, MyPeopleStates state) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              "Create People",
              style: TBIBFontStyle.h2,
            )),
            SizedBox(
              height: spacing3,
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
                        controller: peopleNameController,
                        label: 'People Name *',
                        type: TextInputType.text,
                        validate: (String? val) {
                          if (val == null || val.isEmpty || val.length < 3) {
                            return "min 3 characters";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: spacing15,
                    ),
                    defaultFormField(
                        context: context,
                        controller: telController,
                        label: 'Telephone',
                        type: TextInputType.number,
                        validate: (String? val) {
                          if (val == null || val.isEmpty) {
                            telController.text = val = "0";
                            return null;
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
                        controller: cityController,
                        label: 'City *',
                        type: TextInputType.text,
                        validate: (String? val) {
                          if (val == null || val.isEmpty) {
                            return "empty !!";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: spacing15,
                    ),
                    state is MyPeopleLoadingButton
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
                              CreatePeopleModel createPeopleModel =
                                  CreatePeopleModel(
                                      name: peopleNameController.text,
                                      tel: telController.text,
                                      city: cityController.text);
                              myPeopleCubit
                                  .createPeopleClicked(createPeopleModel);
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
