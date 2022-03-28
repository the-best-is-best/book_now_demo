import 'dart:developer';
import '../../cubit/people_states/my_people_cubit.dart';

void createPeopleMessages() {
  MyPeopleCubit cubitPeople = MyPeopleCubit.get(MyPeopleCubit.context!);
  cubitPeople.getPeople(true);
}

void updatePeopleMessages(int id) {
  log("id updated : " + id.toString());
  MyPeopleCubit cubitPeople = MyPeopleCubit.get(MyPeopleCubit.context!);
  cubitPeople.getUpdatePeople(id);
}
