import 'package:book_now_demo/screens/travel/travel_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tbib_style/style/font_style.dart';

import '../../../shared/cubit/travel_states/my_travel_cubit.dart';
import '../../../shared/cubit/travel_states/travel_states.dart';

Widget selectTravelTab() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Builder(builder: (context) {
        final query = MediaQuery.of(context).size;

        final MyTravelCubit cubitTravel = MyTravelCubit.get(context);
        return BlocConsumer<MyTravelCubit, MyTravelsStates>(
          listener: (BuildContext context, MyTravelsStates state) {},
          builder: (BuildContext context, MyTravelsStates state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(child: Text("Select Travel", style: TBIBFontStyle.h3)),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                thickness: 3,
              ),
              const SizedBox(
                height: 5,
              ),
              cubitTravel.myTravel.isNotEmpty
                  ? buildListView(
                      myTravelWatch: cubitTravel,
                      query: query,
                    )
                  : Center(
                      child: Text(
                        "No travel",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    )
            ],
          ),
        );
      }),
    ],
  );
}

ListView buildListView({
  required MyTravelCubit myTravelWatch,
  required Size query,
}) {
  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: myTravelWatch.myTravel.length,
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: SizedBox(
            width: query.width,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        duration: const Duration(microseconds: 500),
                        type: PageTransitionType.fade,
                        child: TravelDetailsScreen(
                            travel: myTravelWatch.myTravel[index])));
              },
              child: Text(myTravelWatch.myTravel[index].name),
            )),
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return const Divider(
        thickness: 2,
      );
    },
  );
}
