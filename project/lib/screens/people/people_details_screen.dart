import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbib_style/style/font_style.dart';

import '../../components/form_field.dart';
import '../../shared/cubit/people_states/my_people_cubit.dart';
import '../../shared/cubit/people_states/my_people_stares.dart';
import '../../shared/init_page.dart';
import '../../shared/modals/people_model.dart';
import '../../shared/style/main_style.dart';

class PeopleDetailsScreen extends StatefulWidget {
  final PeopleModel people;

  const PeopleDetailsScreen({required this.people, Key? key}) : super(key: key);

  @override
  _PeopleDetailsScreenState createState() => _PeopleDetailsScreenState();
}

class _PeopleDetailsScreenState extends State<PeopleDetailsScreen> {
  final _keyForm = GlobalKey<FormState>();

  final newNamePeopleController = TextEditingController();

  final newTelController = TextEditingController();

  final newcityController = TextEditingController();

  bool firstload = false;
  @override
  void initState() {
    initPage(context);
    if (!firstload) {
      newNamePeopleController.text = widget.people.name;
      newTelController.text = widget.people.tel.toString();
      newcityController.text = widget.people.city;
      firstload = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MyPeopleCubit myPeopleCubit = MyPeopleCubit.get(context);

    final myPeople = myPeopleCubit.myPeople
        .firstWhere((people) => people.id == widget.people.id);

    return BlocConsumer<MyPeopleCubit, MyPeopleStates>(
      listener: (BuildContext context, MyPeopleStates state) {
        if (state is MyPeopleUpdateSuccess) {
          BotToast.showText(text: "Upadated");
        } else if (state is MyPeopleUpdateFailed) {}
      },
      builder: (BuildContext context, MyPeopleStates state) => Scaffold(
        appBar: AppBar(
          title: Text("${myPeople.name} "),
          actions: [
            IconButton(
              icon: myPeopleCubit.editRoomActive
                  ? const FaIcon(FontAwesomeIcons.eye)
                  : const FaIcon(FontAwesomeIcons.penToSquare),
              onPressed: () {
                myPeopleCubit.inEdit();
              },
            )
          ],
        ),
        body: myPeopleCubit.editRoomActive
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Card(
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: spacing20,
                                  ),
                                  Form(
                                    key: _keyForm,
                                    child: defaultFormField(
                                        context: context,
                                        controller: newNamePeopleController,
                                        label: 'New Name',
                                        type: TextInputType.text,
                                        validate: (String? val) {
                                          if (val != null && val.isEmpty) {
                                            return 'empty !!';
                                          }
                                          return null;
                                        }),
                                  ),
                                  SizedBox(
                                    height: spacing20,
                                  ),
                                  defaultFormField(
                                      context: context,
                                      controller: newTelController,
                                      label: 'Telephone',
                                      type: TextInputType.number,
                                      validate: (String? val) {
                                        if (val == null || val.isEmpty) {
                                          return 'empty !!';
                                        }
                                        int? convertToInt = int.tryParse(val);
                                        if (convertToInt == null) {
                                          return "Number not valid";
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: spacing20,
                                  ),
                                  defaultFormField(
                                      context: context,
                                      controller: newcityController,
                                      label: 'City',
                                      type: TextInputType.text,
                                      validate: (String? val) {
                                        if (val != null && val.isEmpty) {
                                          return 'empty !!';
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: spacing20,
                                  ),
                                  state is MyPeopleLoadingButton
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

                                            myPeopleCubit.updatePeople(
                                              id: widget.people.id,
                                              name:
                                                  newNamePeopleController.text,
                                              tel: int.parse(
                                                  newTelController.text),
                                              city: newcityController.text,
                                            );
                                          },
                                        ),
                                  SizedBox(
                                    height: spacing20,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Card(
                      elevation: 20,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: spacing20,
                                ),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "Name : ",
                                        style: TBIBFontStyle.h3),
                                    TextSpan(
                                      text: widget.people.name,
                                      style: TBIBFontStyle.h4,
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: spacing15,
                                ),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "Telephone : ",
                                        style: TBIBFontStyle.h3),
                                    TextSpan(
                                      text: widget.people.tel,
                                      style: TBIBFontStyle.h4,
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: spacing15,
                                ),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "City : ",
                                        style: TBIBFontStyle.h3),
                                    TextSpan(
                                        text: widget.people.city,
                                        style: TBIBFontStyle.h4),
                                  ]),
                                ),
                                SizedBox(
                                  height: spacing20,
                                ),
                              ],
                            ),
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
