import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tragnambo/models/data_models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost/insert_etudiant.php';

  // Récupérer toutes les données et le total
  Future<Map<String, dynamic>> getAllData() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> etudiants = jsonResponse["etudiants"];
      int totalEtudiants = jsonResponse["total_etudiants"];
      int totalDoyen = jsonResponse["total_doyen"];
      int totalAncien = jsonResponse["total_ancien"];
      int totalNovice = jsonResponse["total_novice"];

      return {
        'etudiants':
            etudiants.map((json) => DataModels.fromJson(json)).toList(),
        'total': totalEtudiants,
        'total_doyen': totalDoyen,
        'total_ancien': totalAncien,
        'total_novice': totalNovice,
      };
    } else {
      throw Exception('Échec du chargement des données');
    }
  }

  // Insérer une nouvelle donnée
  Future<void> insertData(DataModels data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'numero_matricule': data.numero_matricule,
        'nom': data.nom,
        'prenom': data.prenom,
        'contact': data.contact,
        'logement': data.logement,
        'promotion': data.promotion,
        'etablissement': data.etablissement,
        'niveau': data.niveau,
        'statut': data.status,
      }),
    );

    if (response.statusCode != 200) {
      final responseData = json.decode(response.body);
      throw Exception(responseData['error'] ?? 'Échec de l\'insertion');
    }
  }

  // Supprimer une donnée
  Future<void> deleteData(String numeroMatricule) async {
    final response = await http.delete(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'numero_matricule': numeroMatricule,
      }),
    );

    if (response.statusCode != 200) {
      final responseData = json.decode(response.body);
      throw Exception(responseData['error'] ?? 'Échec de la suppression');
    }
  }

  Future<void> updateData(DataModels data) async {
    final response = await http.put(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'numero_matricule': data.numero_matricule,
        'nom': data.nom,
        'prenom': data.prenom,
        'contact': data.contact,
        'logement': data.logement,
        'promotion': data.promotion,
        'etablissement': data.etablissement,
        'niveau': data.niveau,
        'statut': data.status,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      final responseData = json.decode(response.body);
      throw Exception(responseData['error'] ?? 'Échec de la mise à jour');
    }
  }

  // Récupérer le nombre total d'étudiants
  Future<int> getTotalEtudiants() async {
    final response = await http.get(Uri.parse('$baseUrl/total_etudiants'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['total_etudiants'];
    } else {
      throw Exception('Erreur de chargement du total des étudiants');
    }
  }
}
