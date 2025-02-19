import 'package:tragnambo/models/data_models.dart';

class StudentResponse {
  final List<DataModels> etudiants;
  final int totalEtudiants;

  StudentResponse({required this.etudiants, required this.totalEtudiants});

  factory StudentResponse.fromJson(Map<String, dynamic> json) {
    return StudentResponse(
      etudiants: List<DataModels>.from(
          json['etudiants'].map((student) => DataModels.fromJson(student))),
      totalEtudiants: json['total_etudiants'],
    );
  }
}
