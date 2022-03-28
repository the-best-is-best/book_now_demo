import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components/form_field.dart';
import '../../shared/cubit/travel_states/my_travel_cubit.dart';
import '../../shared/cubit/travel_states/travel_states.dart';
import '../../shared/modals/travel_model.dart';

class TravelDetailsScreen extends StatefulWidget {
  final TravelModel travel;

  const TravelDetailsScreen({required this.travel, Key? key}) : super(key: key);

  @override
  _TravelDetailsScreenState createState() => _TravelDetailsScreenState();
}

class _TravelDetailsScreenState extends State<TravelDetailsScreen> {
  final _keyForm = GlobalKey<FormState>();

  final newNameTravelController = TextEditingController();

  bool firstload = false;
  @override
  void initState() {
    if (!firstload) {
      newNameTravelController.text = widget.travel.name;
      firstload = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MyTravelCubit cubitTravel = MyTravelCubit.get(context);
    return BlocConsumer<MyTravelCubit, MyTravelsStates>(
      listener: (BuildContext context, MyTravelsStates state) {
        if (state is MyTravelsUpdateSuccess) {
          newNameTravelController.text = "";
          BotToast.showText(text: "Upadated");
        }
      },
      builder: (BuildContext context, MyTravelsStates state) => Scaffold(
        appBar: AppBar(
          title: const Text("Edit travel"),
          actions: [
            IconButton(
              icon: cubitTravel.editTravelActive
                  ? const FaIcon(FontAwesomeIcons.eye)
                  : const FaIcon(FontAwesomeIcons.penToSquare),
              onPressed: () {
                cubitTravel.inEdit();
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
                        cubitTravel.editTravelActive
                            ? Column(
                                children: [
                                  Form(
                                    key: _keyForm,
                                    child: defaultFormField(
                                        context: context,
                                        controller: newNameTravelController,
                                        label: 'New Name',
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
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  state is MyTravelsLoadingButton
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                          child: const Text("Edit"),
                                          onPressed: () {
                                            _keyForm.currentState!.save();
                                            if (!_keyForm.currentState!
                                                .validate()) {
                                              return;
                                            }
                                            _keyForm.currentState!.save();

                                            cubitTravel.updateTravel(
                                              id: widget.travel.id,
                                              name:
                                                  newNameTravelController.text,
                                            );
                                          },
                                        ),
                                ],
                              )
                            : Text(
                                "Name : ${widget.travel.name}",
                                style: Theme.of(context).textTheme.headline3,
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
