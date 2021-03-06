class PeopleModel {
  final int id;
  String name;
  String tel;
  String city;

  PeopleModel({
    required this.id,
    required this.name,
    required this.tel,
    required this.city,
  });
  PeopleModel.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id'].toString()),
        name = json['name'],
        tel = json['tel'].toString(),
        city = json['city'];
}

class CreatePeopleModel {
  final String name;
  final String tel;
  final String city;

  CreatePeopleModel({
    required this.name,
    required this.tel,
    required this.city,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'tel': tel,
        'city': city,
      };
}
