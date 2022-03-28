class CreateProjectModel {
  String projectName;
  int price;
  int houseId;
  String endDate;

  CreateProjectModel({
    required this.projectName,
    required this.price,
    required this.houseId,
    required this.endDate,
  });

  Map<String, dynamic> toJson() => {
        'project_name': projectName,
        'price': price,
        'house_id': houseId,
        'end_date': endDate,
      };
}

class ProjectsModel {
  int id;
  String projectName;
  int houseId;
  int price;
  DateTime endDate;

  ProjectsModel({
    required this.id,
    required this.projectName,
    required this.houseId,
    required this.price,
    required this.endDate,
  });

  ProjectsModel.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id'].toString()),
        projectName = json['project_name'],
        price = int.parse(json['price'].toString()),
        houseId = int.parse(json['house_id'].toString()),
        endDate = DateTime.parse(json['end_date']);
}
