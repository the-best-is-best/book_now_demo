import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_style/style/font_style.dart';

import '../../../shared/cubit/projects_states/my_project_cubit.dart';
import '../../../shared/cubit/projects_states/my_projects_states.dart';
import '../../../shared/style/main_style.dart';

Widget selectProjectTab() {
  return Builder(builder: (context) {
    final MyProjectCubit cubitProject = MyProjectCubit();
    MyProjectCubit.context = context;
    final query = MediaQuery.of(context).size;

    // final reportsWatch = context.read<ReportsProvider>();
    // final reportsRead = context.read<ReportsProvider>();
    // final relPeopleRead = context.read<RelPeopleProvider>();

    // final checkDataRead = context.read<CheckDataProvider>();
    // final checkDataWatch = context.watch<CheckDataProvider>();
    // final myRoomWatch = context.watch<RoomsProvider>();

    // final travelDataWatch = context.watch<TravelProvider>();

    return BlocConsumer<MyProjectCubit, MyProjectsStates>(
      listener: (BuildContext context, MyProjectsStates state) {
        if (state is MyProjectsAddSuccess) {
        } else if (state is MyProjectsAddFailed) {}
      },
      builder: (BuildContext context, MyProjectsStates state) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Text(
            "Select Project",
            style: TBIBFontStyle.h2,
          )),
          SizedBox(
            height: spacing5,
          ),
          Divider(
            thickness: spacing3,
          ),
          Center(
            child: Container(
              child: cubitProject.myProject.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cubitProject.myProject.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: SizedBox(
                              width: query.width,
                              child: ElevatedButton(
                                child: Text(
                                  cubitProject.myProject[index].projectName,
                                  style: TBIBFontStyle.h4
                                      .copyWith(color: Colors.white),
                                ),
                                onPressed: () async {
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     PageTransition(
                                  //         duration: const Duration(
                                  //             milliseconds: 500),
                                  //         type: PageTransitionType.fade,
                                  //         child:
                                  //             const ReportsScreen()));
                                  // reportsRead.getDataProject(
                                  //     myProjectWatch.myProject[index]);
                                  // await checkDataRead
                                  //     .getRelListenData(
                                  //         fromProject: true)
                                  //     .then((val) async {
                                  //   if (val == true) {
                                  //     checkDataRead
                                  //         .displayLoading(true);

                                  //     if (checkDataRead
                                  //         .insertRelPeople.isNotEmpty) {
                                  //       await reportsRead
                                  //           .getDataRelPeople(
                                  //               checkDataWatch
                                  //                   .insertRelPeople,
                                  //               myRoomWatch.myRooms)
                                  //           .then((_) async {
                                  //         reportsRead
                                  //             .getnumberofBedsRemaining();
                                  //       }).then((_) {
                                  //         reportsRead.getMaxPage();

                                  //         reportsRead.getDataPage(1);
                                  //       });
                                  //     }
                                  //     checkDataRead.endRelList();
                                  //     checkDataRead
                                  //         .displayLoading(false);

                                  //     relPeopleRead.myHouse(
                                  //         myProjectWatch
                                  //             .myProject[index]
                                  //             .houseId);

                                  //     relPeopleRead.getRooms(
                                  //         myRoomWatch.myRooms,
                                  //         reportsWatch);

                                  //     reportsRead.calcMangmentData(
                                  //         travelDataWatch.myTravel);
                                  //   }
                                  // });
                                },
                              )),
                        ));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          thickness: 2,
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No projects",
                        style: TBIBFontStyle.h4,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  });
}
