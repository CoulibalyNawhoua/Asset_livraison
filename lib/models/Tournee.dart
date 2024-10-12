class Tournees {
  int id;
  DateTime date;
  int vehiculeId;
  int societeId;
  int status;
  String uuid;
  int deleted;
  int addBy;
  dynamic editBy;
  DateTime createdAt;
  DateTime updatedAt;
  String code;
  dynamic dateCloture;
  dynamic territoireId;
  int livreurId;
  int deploiementsCount;
  Vehicule vehicule;

  Tournees({
    required this.id,
    required this.date,
    required this.vehiculeId,
    required this.societeId,
    required this.status,
    required this.uuid,
    required this.deleted,
    required this.addBy,
    required this.editBy,
    required this.createdAt,
    required this.updatedAt,
    required this.code,
    required this.dateCloture,
    required this.territoireId,
    required this.livreurId,
    required this.deploiementsCount,
    required this.vehicule,
  });

  factory Tournees.fromJson(Map<String, dynamic> json) => Tournees(
    id: json["id"],
    date: DateTime.parse(json["date"]),
    vehiculeId: json["vehicule_id"],
    societeId: json["societe_id"],
    status: json["status"],
    uuid: json["uuid"],
    deleted: json["deleted"],
    addBy: json["add_by"],
    editBy: json["edit_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    code: json["code"],
    dateCloture: json["date_cloture"] == null ? null : DateTime.parse(json["date_cloture"]),
    territoireId: json["territoire_id"],
    livreurId: json["livreur_id"],
    deploiementsCount: json["deploiements_count"],
    vehicule: Vehicule.fromJson(json["vehicule"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date.toIso8601String(),
    "vehicule_id": vehiculeId,
    "societe_id": societeId,
    "status": status,
    "uuid": uuid,
    "deleted": deleted,
    "add_by": addBy,
    "edit_by": editBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "code": code,
    "date_cloture": dateCloture?.toIso8601String(),
    "territoire_id": territoireId,
    "livreur_id": livreurId,
    "deploiements_count": deploiementsCount,
    "vehicule": vehicule.toJson(),
  };
}

class Vehicule {
  int id;
  String libelle;
  String matricule;
  String typeVehicule;
  dynamic image;
  int status;
  int deleted;

  Vehicule({
    required this.id,
    required this.libelle,
    required this.matricule,
    required this.typeVehicule,
    required this.image,
    required this.status,
    required this.deleted,
  });

  factory Vehicule.fromJson(Map<String, dynamic> json) => Vehicule(
    id: json["id"],
    libelle: json["libelle"],
    matricule: json["matricule"],
    typeVehicule: json["type_vehicule"],
    image: json["image"],
    status: json["status"],
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "libelle": libelle,
    "matricule": matricule,
    "type_vehicule": typeVehicule,
    "image": image,
    "status": status,
    "deleted": deleted,
  };
}
