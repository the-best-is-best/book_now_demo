class TravelModel {
  int id;
  String name;

  TravelModel({
    required this.id,
    required this.name,
  });
  TravelModel.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id'].toString()),
        name = json['name'];
}

class CreateTravelModel {
  String name;

  CreateTravelModel({
    required this.name,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
