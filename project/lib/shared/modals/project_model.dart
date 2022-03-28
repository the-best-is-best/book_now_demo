class CreateProjectModel {
  final String projectName;
  final int price;
  final int houseId;
  final String endDate;

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
  final int id;
  final String projectName;
  final int houseId;
  final int price;
  final DateTime endDate;

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
