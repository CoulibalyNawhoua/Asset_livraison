class Delivery {
  int id;
  String ordreDeploiement;
  int status;
  String dPdv;
  String dContact;
  String dAddresse;
  String dLatitude;
  String dLongitude;
  String codeTournee;

  Delivery({
    required this.id,
    required this.ordreDeploiement,
    required this.status,
    required this.dPdv,
    required this.dContact,
    required this.dAddresse,
    required this.dLatitude,
    required this.dLongitude,
    required this.codeTournee,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
    id: json["id"],
    ordreDeploiement: json["ordre_deploiement"],
    status: json["status"],
    dPdv: json["d_pdv"],
    dContact: json["d_contact"],
    dAddresse: json["d_addresse"],
    dLatitude: json["d_latitude"],
    dLongitude: json["d_longitude"],
    codeTournee: json["CodeTournee"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ordre_deploiement": ordreDeploiement,
    "status": status,
    "d_pdv": dPdv,
    "d_contact": dContact,
    "d_addresse": dAddresse,
    "d_latitude": dLatitude,
    "d_longitude": dLongitude,
    "CodeTournee": codeTournee,
  };
}


class DeliveryDetail {
  int id;
  String ordreDeploiement;
  dynamic dateValidation;
  int status;
  String dPdv;
  String dContact;
  String dAddresse;
  String dLatitude;
  String dLongitude;
  String dTerritoire;
  String dCanal;
  String dZone;
  String dPdvCategorie;
  int tourneeId;
  int affectationId;
  Tournee tournee;
  Affect affect;

  DeliveryDetail({
    required this.id,
    required this.ordreDeploiement,
    required this.dateValidation,
    required this.status,
    required this.dPdv,
    required this.dContact,
    required this.dAddresse,
    required this.dLatitude,
    required this.dLongitude,
    required this.dTerritoire,
    required this.dCanal,
    required this.dZone,
    required this.dPdvCategorie,
    required this.tourneeId,
    required this.affectationId,
    required this.tournee,
    required this.affect,
  });

  factory DeliveryDetail.fromJson(Map<String, dynamic> json) => DeliveryDetail(
    id: json["id"],
    ordreDeploiement: json["ordre_deploiement"] ?? "",
    dateValidation: json["date_validation"] != null ? DateTime.parse(json["date_validation"]) : null,
    status: json["status"],
    dPdv: json["d_pdv"] ?? "",
    dContact: json["d_contact"] ?? "",
    dAddresse: json["d_addresse"] ?? "",
    dLatitude: json["d_latitude"] ?? "",
    dLongitude: json["d_longitude"] ?? "",
    dTerritoire: json["d_territoire"] ?? "",
    dCanal: json["d_canal"] ?? "",
    dZone: json["d_zone"] ?? "",
    dPdvCategorie: json["d_pdv_categorie"] ?? "",
    tourneeId: json["tournee_id"],
    affectationId: json["affectation_id"],
    tournee: Tournee.fromJson(json["tournee"]),
    affect: Affect.fromJson(json["affect"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ordre_deploiement": ordreDeploiement,
    "date_validation": dateValidation?.toIso8601String(),
    "status": status,
    "d_pdv": dPdv,
    "d_contact": dContact,
    "d_addresse": dAddresse,
    "d_latitude": dLatitude,
    "d_longitude": dLongitude,
    "d_territoire": dTerritoire,
    "d_canal": dCanal,
    "d_zone": dZone,
    "d_pdv_categorie": dPdvCategorie,
    "tournee_id": tourneeId,
    "affectation_id": affectationId,
    "tournee": tournee.toJson(),
    "affect": affect.toJson(),
  };
}

class Affect {
    int id;
    String code;
    int materielId;
    Materiel materiel;

    Affect({
        required this.id,
        required this.code,
        required this.materielId,
        required this.materiel,
    });

    factory Affect.fromJson(Map<String, dynamic> json) => Affect(
        id: json["id"],
        code: json["code"],
        materielId: json["materiel_id"],
        materiel: Materiel.fromJson(json["materiel"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "materiel_id": materielId,
        "materiel": materiel.toJson(),
    };
}

class Materiel {
    int id;
    String numSerie;
    int status;
    String uuid;
    DateTime dateAcquisition;
    int societeId;
    String qrcodePath;
    String materielId;
    MaterielForDeploy materielForDeploy;

    Materiel({
        required this.id,
        required this.numSerie,
        required this.status,
        required this.uuid,
        required this.dateAcquisition,
        required this.societeId,
        required this.qrcodePath,
        required this.materielId,
        required this.materielForDeploy,
    });

    factory Materiel.fromJson(Map<String, dynamic> json) => Materiel(
        id: json["id"],
        numSerie: json["num_serie"],
        status: json["status"],
        uuid: json["uuid"],
        dateAcquisition: DateTime.parse(json["date_acquisition"]),
        societeId: json["societe_id"],
        qrcodePath: json["qrcode_path"],
        materielId: json["materiel_id"],
        materielForDeploy: MaterielForDeploy.fromJson(json["materiel_for_deploy"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "num_serie": numSerie,
        "status": status,
        "uuid": uuid,
        "date_acquisition": dateAcquisition.toIso8601String(),
        "societe_id": societeId,
        "qrcode_path": qrcodePath,
        "materiel_id": materielId,
        "materiel_for_deploy": materielForDeploy.toJson(),
    };
}

class MaterielForDeploy {
    String code;
    String libelle;
    int categorieId;
    int marqueId;
    int modeleId;
    Categorie categorie;
    Categorie marque;
    Categorie modele;

    MaterielForDeploy({
        required this.code,
        required this.libelle,
        required this.categorieId,
        required this.marqueId,
        required this.modeleId,
        required this.categorie,
        required this.marque,
        required this.modele,
    });

    factory MaterielForDeploy.fromJson(Map<String, dynamic> json) => MaterielForDeploy(
        code: json["code"],
        libelle: json["libelle"],
        categorieId: json["categorie_id"],
        marqueId: json["marque_id"],
        modeleId: json["modele_id"],
        categorie: Categorie.fromJson(json["categorie"]),
        marque: Categorie.fromJson(json["marque"]),
        modele: Categorie.fromJson(json["modele"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "libelle": libelle,
        "categorie_id": categorieId,
        "marque_id": marqueId,
        "modele_id": modeleId,
        "categorie": categorie.toJson(),
        "marque": marque.toJson(),
        "modele": modele.toJson(),
    };
}



class Categorie {
    int id;
    String libelle;

    Categorie({
        required this.id,
        required this.libelle,
    });

    factory Categorie.fromJson(Map<String, dynamic> json) => Categorie(
        id: json["id"],
        libelle: json["libelle"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
    };
}

class Tournee {
    int id;
    String code;
    DateTime date;
    int vehiculeId;
    dynamic dateCloture;
    dynamic territoireId;
    int livreurId;
    Vehicule vehicule;

    Tournee({
        required this.id,
        required this.code,
        required this.date,
        required this.vehiculeId,
        required this.dateCloture,
        required this.territoireId,
        required this.livreurId,
        required this.vehicule,
    });

    factory Tournee.fromJson(Map<String, dynamic> json) => Tournee(
        id: json["id"],
        code: json["code"],
        date: DateTime.parse(json["date"]),
        vehiculeId: json["vehicule_id"],
        dateCloture: json["date_cloture"],
        territoireId: json["territoire_id"],
        livreurId: json["livreur_id"],
        vehicule: Vehicule.fromJson(json["vehicule"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "date": date.toIso8601String(),
        "vehicule_id": vehiculeId,
        "date_cloture": dateCloture,
        "territoire_id": territoireId,
        "livreur_id": livreurId,
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