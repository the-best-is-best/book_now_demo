import 'package:book_now_demo/shared/cubit/rooms_states/rooms_cubit.dart';

void createRoomMessages() {
  MyRoomsCubit cubit = MyRoomsCubit.get(MyRoomsCubit.context!);
  cubit.getRooms();
}

void updateRoomMessages(id) {
  MyRoomsCubit cubit = MyRoomsCubit.get(MyRoomsCubit.context!);
  cubit.getUpdateRoom(id);
}
