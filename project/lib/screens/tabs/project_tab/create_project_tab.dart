import 'package:book_now_demo/shared/cubit/houses_states/my_house_cubit.dart';
import 'package:book_now_demo/shared/cubit/houses_states/my_houses_states.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tbib_style/style/font_style.dart';

import '../../../components/date_time_picker.dart';
import '../../../components/form_field.dart';
import '../../../shared/cubit/projects_states/my_project_cubit.dart';
import '../../../shared/cubit/projects_states/my_projects_states.dart';
import '../../../shared/modals/project_model.dart';
import '../../../shared/style/main_style.dart';

Widget createProjectTab() {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  return Builder(
    builder: (context) {
      final MyProjectCubit cubitProject = MyProjectCubit.get(context);
      MyProjectCubit.context = context;

      endDateController.text = DateTime.now().toIso8601String();

      return BlocConsumer<MyProjectCubit, MyProjectsStates>(
        listener: (BuildContext context, MyProjectsStates state) {
          if (state is MyProjectsAddSuccess) {
          } else if (state is MyProjectsAddFailed) {}
        },
        builder: (BuildContext context, MyProjectsStates state) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Text(
              "Create Project",
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BlocConsumer<MyProjectCubit, MyProjectsStates>(
                      listener: (BuildContext context, MyProjectsStates state) {
                        if (state is MyProjectsAddSuccess) {
                          projectNameController.text =
                              priceController.text = "";
                          endDateController.text =
                              DateTime.now().toIso8601String();
                          cubitProject.changeHouseSelected(null);
                          BotToast.showText(
                            text: "Added",
                            duration: const Duration(seconds: 3),
                          );
                        }
                      },
                      builder: (BuildContext context, MyProjectsStates state) =>
                          defaultFormField(
                              context: context,
                              controller: projectNameController,
                              label: 'Project Name *',
                              type: TextInputType.text,
                              validate: (String? val) {
                                if (val == null ||
                                    val.isEmpty ||
                                    val.length < 3) {
                                  return "min 3 characters";
                                }
                                return null;
                              }),
                    ),
                    SizedBox(
                      height: spacing15,
                    ),
                    Builder(builder: (context) {
                      final MyHousesCubit cubitHouse =
                          MyHousesCubit.get(context);
                      MyHousesCubit.context = context;

                      return BlocConsumer<MyHousesCubit, MyHousesStates>(
                        listener: (BuildContext context, MyHousesStates state) {
                          if (state is MyHousesAddSuccess) {
                          } else if (state is MyHousesAddFailed) {}
                        },
                        builder: (BuildContext context, MyHousesStates state) =>
                            Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 25),
                          width: MediaQuery.of(context).size.width,
                          child: DropdownButtonFormField<int?>(
                            iconSize: 45.h,
                            icon: const Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            elevation: 16,
                            style: TBIBFontStyle.h4,
                            hint: Text(
                              'Select House *',
                              style: TBIBFontStyle.h4,
                            ),
                            value: cubitProject.houseSelected,
                            items: cubitHouse.myHouses
                                .map((house) => DropdownMenuItem(
                                      value: house.id,
                                      child: Text(
                                        house.name,
                                        style: TBIBFontStyle.h4,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              cubitProject.changeHouseSelected(value);
                            },
                            validator: (int? val) {
                              if (val == null || val == 0) {
                                return "select house plz";
                              }
                              return null;
                            },
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      height: spacing15,
                    ),
                    defaultFormField(
                        context: context,
                        controller: priceController,
                        label: 'Price *',
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
                    SizedBox(
                      height: spacing15,
                    ),
                    defaultDateTimePicker(
                        context: context,
                        controller: endDateController,
                        label: "End Date *",
                        validator: (String? val) {
                          if (val == null ||
                              val.isEmpty ||
                              DateTime.parse(val).isBefore(DateTime.now())) {
                            return "Date is not correct";
                          }
                          return null;
                        }),
                    SizedBox(
                      height: spacing15,
                    ),
                    state is MyHousesGetData
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
                              CreateProjectModel createProjectModel =
                                  CreateProjectModel(
                                      projectName: projectNameController.text,
                                      price: int.parse(priceController.text),
                                      houseId: cubitProject.houseSelected!,
                                      endDate: endDateController.text);
                              cubitProject
                                  .createProjectClicked(createProjectModel);
                            },
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
