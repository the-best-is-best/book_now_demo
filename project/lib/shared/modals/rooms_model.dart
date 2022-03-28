class CreateRoomModel {
  String name;
  int houseId;
  int floor;
  int numbersOfBed;

  CreateRoomModel({
    required this.name,
    required this.houseId,
    required this.floor,
    required this.numbersOfBed,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'house_id': houseId,
        'floor': floor,
        'numbers_of_bed': numbersOfBed,
      };
}

class RoomsModel {
  int id;
  int name;
  int houseId;
  int floor;
  int numbersOfBed;
  int bunkBed;

  RoomsModel({
    required this.id,
    required this.name,
    required this.houseId,
    required this.floor,
    required this.numbersOfBed,
    required this.bunkBed,
  });
  RoomsModel.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id'].toString()),
        name = int.parse(json['name'].toString()),
        houseId = int.parse(json['house_id'].toString()),
        floor = int.parse(json['floor'].toString()),
        numbersOfBed = int.parse(json['numbers_of_bed'].toString()),
        bunkBed = int.parse(json['bunk_bed'].toString());
}

class AddBunkBed {
  int houseId;
  int floor;
  int room;
  int numbersOfBed;
  int bunkBed;
  int id;

  AddBunkBed({
    required this.id,
    required this.houseId,
    required this.floor,
    required this.room,
    required this.numbersOfBed,
    required this.bunkBed,
  });

  Map<String, dynamic> toJson() => {
        'house_id': houseId,
        'floor': floor,
        'room': room,
        'numbers_of_bed': numbersOfBed,
        'bunk_bed': bunkBed,
        'id': id
      };
}
