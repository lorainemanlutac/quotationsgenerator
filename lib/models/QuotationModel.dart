import 'dart:convert';

QuotationModel quotationModelFromJson(String str) {
  final jsonData = json.decode(str);

  return QuotationModel.fromMap(jsonData);
}

String quotationModelToJson(QuotationModel data) {
  final dyn = data.toMap();

  return json.encode(dyn);
}

String toJson(List<List<String>> data) {
  return json.encode(data);
}

class QuotationModel {
  final int id;
  final String emailAddress;
  final String project;
  final String location;
  final String particulars;
  final String note;
  final String createdDate;
  final String changedDate;

  QuotationModel({
    required this.id,
    required this.emailAddress,
    required this.project,
    required this.location,
    required this.particulars,
    required this.note,
    required this.createdDate,
    required this.changedDate,
  });

  factory QuotationModel.fromMap(Map<String, dynamic> json) =>
      new QuotationModel(
        id: json['id'],
        emailAddress: json['emailAddress'],
        project: json['project'],
        location: json['location'],
        particulars: json['particulars'],
        note: json['note'],
        createdDate: json['createdDate'],
        changedDate: json['changedDate'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'emailAddress': emailAddress,
        'project': project,
        'location': location,
        'particulars': particulars,
        'note': note,
        'createdDate': createdDate,
        'changedDate': changedDate,
      };
}
