import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tbib_style/tbib_style.dart';

import '../../../components/search_component.dart';
import '../../../shared/cubit/people_states/my_people_cubit.dart';
import '../../../shared/cubit/people_states/my_people_stares.dart';
import '../../people/people_details_screen.dart';

Widget selectPeopleTab() {
  final searchPeopleController = TextEditingController();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Builder(builder: (context) {
        final MyPeopleCubit myPeopleCubit = MyPeopleCubit.get(context);
        final Size query = MediaQuery.of(context).size;
        return BlocConsumer<MyPeopleCubit, MyPeopleStates>(
          listener: (BuildContext context, MyPeopleStates state) {},
          builder: (BuildContext context, MyPeopleStates state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              myPeopleCubit.myPeople.length > 20
                  ? buildSearchComponent(
                      context: context,
                      searchController: searchPeopleController,
                      searchTitle: "people name",
                      onSubmit: (String? val) {
                        myPeopleCubit.searchPeople(val!);
                      },
                    )
                  : Container(),
              Center(
                  child: Text(
                "Select People",
                style: TBIBFontStyle.h3,
              )),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                thickness: 3,
              ),
              const SizedBox(
                height: 5,
              ),
              searchPeopleController.text.isEmpty
                  ? myPeopleCubit.myPeople.isNotEmpty
                      ? buildListView(
                          myPeopleWatch: myPeopleCubit,
                          query: query,
                          searchPeopleController: searchPeopleController,
                        )
                      : Center(
                          child: Text(
                            "No people",
                            style: TBIBFontStyle.h4,
                          ),
                        )
                  : myPeopleCubit.searchMypeople.isNotEmpty
                      ? buildListView(
                          searchPeopleController: searchPeopleController,
                          myPeopleWatch: myPeopleCubit,
                          query: query,
                        )
                      : Center(
                          child: Text(
                            "No people",
                            style: TBIBFontStyle.h4,
                          ),
                        ),
            ],
          ),
        );
      }),
    ],
  );
}

ListView buildListView({
  required TextEditingController searchPeopleController,
  required MyPeopleCubit myPeopleWatch,
  required Size query,
}) {
  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: searchPeopleController.text.isEmpty
        ? myPeopleWatch.myPeople.length
        : myPeopleWatch.searchMypeople.length,
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: myPeopleWatch.loadingSearch
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: query.width,
                child: searchPeopleController.text.isEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  duration: const Duration(milliseconds: 500),
                                  type: PageTransitionType.fade,
                                  child: PeopleDetailsScreen(
                                      people: myPeopleWatch.myPeople[index])));
                        },
                        child: Text(
                          myPeopleWatch.myPeople[index].name,
                          style: TBIBFontStyle.h4.copyWith(color: Colors.white),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  duration: const Duration(milliseconds: 500),
                                  type: PageTransitionType.fade,
                                  child: PeopleDetailsScreen(
                                      people: myPeopleWatch
                                          .searchMypeople[index])));
                        },
                        child: Text(myPeopleWatch.searchMypeople[index].name),
                      ),
              ),
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return const Divider(
        thickness: 2,
      );
    },
  );
}
