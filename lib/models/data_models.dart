class DataModels {
  final int? id;
  final String numero_matricule;
  final String nom;
  final String prenom;
  final String contact;
  final String logement;
  final String promotion;
  final String etablissement;
  final String niveau;
  final String status;

  DataModels(
      {this.id,
      required this.numero_matricule,
      required this.nom,
      required this.prenom,
      required this.contact,
      required this.logement,
      required this.promotion,
      required this.etablissement,
      required this.niveau,
      required this.status});

  factory DataModels.fromJson(Map<String, dynamic> json) {
    return DataModels(
        id: json["id"],
        numero_matricule: json["numero_matricule"],
        nom: json["nom"],
        prenom: json["prenom"],
        contact: json["contact"],
        logement: json["logement"],
        promotion: json["promotion"],
        etablissement: json["etablissement"],
        niveau: json["niveau"],
        status: json["statut"]);
  }

  // Add this method
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "numero_matricule": numero_matricule,
      "nom": nom,
      "prenom": prenom,
      "contact": contact,
      "logement": logement,
      "promotion": promotion,
      "etablissement": etablissement,
      "niveau": niveau,
      "statut": status,
    };
  }
}
