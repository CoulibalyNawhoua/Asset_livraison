class Motif {
  int id;
  String libelle;

  Motif({
    required this.id,
    required this.libelle,
  });

  factory Motif.fromJson(Map<String, dynamic> json) => Motif(
    id: json["id"],
    libelle: json["libelle"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "libelle": libelle,
  };
}
