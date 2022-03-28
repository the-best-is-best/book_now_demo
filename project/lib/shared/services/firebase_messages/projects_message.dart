import 'package:book_now_demo/shared/cubit/projects_states/my_project_cubit.dart';

void createProjectMessage() {
  MyProjectCubit cubit = MyProjectCubit.get(MyProjectCubit.context!);
  cubit.getData(true);
}
