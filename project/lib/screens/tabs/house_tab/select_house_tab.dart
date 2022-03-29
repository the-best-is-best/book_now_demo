import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbib_style/tbib_style.dart';

import '../../../components/expanded/floors_expanded.dart';
import '../../../components/search_component.dart';
import '../../../shared/cubit/houses_states/my_house_cubit.dart';
import '../../../shared/cubit/houses_states/my_houses_states.dart';
import '../../../shared/style/main_style.dart';

Widget selectHousesTab() {
  final searchControllerController = TextEditingController();
  return Column(
    children: [
      Builder(builder: (context) {
        final query = MediaQuery.of(context).size;
        final MyHousesCubit cubitHouse = MyHousesCubit.get(context);
        MyHousesCubit.context = context;

        return BlocConsumer<MyHousesCubit, MyHousesStates>(
          listener: (BuildContext context, MyHousesStates state) {
            if (state is MyHousesAddSuccess) {
            } else if (state is MyHousesAddFailed) {}
          },
          builder: (BuildContext context, MyHousesStates state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cubitHouse.myHouses.length > 20
                  ? buildSearchComponent(
                      context: context,
                      searchController: searchControllerController,
                      searchTitle: "house name",
                      onSubmit: (String? val) {
                        cubitHouse.searchHouse(val!);
                      },
                    )
                  : Container(),
              Center(
                  child: Text(
                "Select Houses",
                style: TBIBFontStyle.h3,
              )),
              SizedBox(
                height: spacing5,
              ),
              const Divider(
                thickness: 3,
              ),
              SizedBox(
                height: spacing5,
              ),
              Center(
                child: searchControllerController.text.isEmpty
                    ? cubitHouse.myHouses.isNotEmpty
                        ? buildListView(
                            myHousesWatch: cubitHouse,
                            query: query,
                            searchControllerController:
                                searchControllerController,
                          )
                        : Center(
                            child: Text(
                              "No houses",
                              style: TBIBFontStyle.h4,
                            ),
                          )
                    : cubitHouse.searchMyHouse.isNotEmpty
                        ? buildListView(
                            searchControllerController:
                                searchControllerController,
                            myHousesWatch: cubitHouse,
                            query: query,
                          )
                        : Center(
                            child: Text(
                              "No Houses",
                              style: TBIBFontStyle.h4,
                            ),
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
  required TextEditingController searchControllerController,
  required MyHousesCubit myHousesWatch,
  required Size query,
}) {
  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: searchControllerController.text.isEmpty
        ? myHousesWatch.myHouses.length
        : myHousesWatch.searchMyHouse.length,
    itemBuilder: (BuildContext context, int index) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: myHousesWatch.loadingSearch
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: query.width,
                  child: ExpandableNotifier(
                    child: ScrollOnExpand(
                      child: ExpandablePanel(
                        header: searchControllerController.text.isEmpty
                            ? Text(
                                "$index - ${myHousesWatch.myHouses[index].name}",
                                style: TBIBFontStyle.h4,
                              )
                            : Text(
                                "$index - ${myHousesWatch.searchMyHouse[index].name}",
                                style: TBIBFontStyle.h4,
                              ),
                        collapsed: Container(),
                        expanded: Container(
                          child: searchControllerController.text.isEmpty
                              ? buildFloorsExpanded(
                                  myHouses: myHousesWatch.myHouses[index],
                                  context: context,
                                  index: index,
                                )
                              : buildFloorsExpanded(
                                  myHouses: myHousesWatch.searchMyHouse[index],
                                  context: context,
                                  index: index,
                                ),
                        ),
                      ),
                    ),
                  ),
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
