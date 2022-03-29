import 'package:book_now_demo/screens/travel/travel_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tbib_style/style/font_style.dart';

import '../../../shared/cubit/travel_states/my_travel_cubit.dart';
import '../../../shared/cubit/travel_states/travel_states.dart';
import '../../../shared/style/main_style.dart';

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
              SizedBox(
                height: spacing5,
              ),
              const Divider(
                thickness: 3,
              ),
              SizedBox(
                height: spacing5,
              ),
              cubitTravel.myTravel.isNotEmpty
                  ? buildListView(
                      myTravelWatch: cubitTravel,
                      query: query,
                    )
                  : Center(
                      child: Text(
                        "No Travel",
                        style: TBIBFontStyle.h4,
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
              child: Text(
                myTravelWatch.myTravel[index].name,
                style: TBIBFontStyle.h4.copyWith(color: Colors.white),
              ),
            )),
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return Divider(
        thickness: 2.h,
      );
    },
  );
}
