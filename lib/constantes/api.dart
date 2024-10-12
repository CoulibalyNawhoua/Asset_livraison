class Api {
  // static const url = "http://192.168.1.73:8000/api";
  // static const imageUrl = 'http://192.168.1.73:8000/storage/';

  static const url = "https://assets-api.distriforce.shop/api";
  static const imageUrl = 'https://assets-api.distriforce.shop/storage/';

  
  static const login = '$url/login-livreur';

  static const listTournee = '$url/livreur-tournee-list';
  static String deliveryWaiting(String uuid) {
    return '$url/tournee-deploiement-encours/$uuid';
  }
  static String deliveryCompleted(String uuid) {
    return '$url/tournee-deploiement-terminer/$uuid';
  }
  static String deliveryCanceled(String uuid) {
    return '$url/tournee-deploiement-annule/$uuid';
  }

  static const listMotif = '$url/refused-motif-list';

  static String annulationLivraison(int deploiement_idd) {
    return '$url/create-deploiement-annule/$deploiement_idd';
  }

    static String confirmationLivraison(int deploiement_id) {
    return '$url/create-deploiement-confirme/$deploiement_id';
  }

  static String deliveryDetails(int id) {
    return '$url/deploiement-materiel-detail/$id';
  }
  static String valideDelivery(int id) {
    return '$url/validate-deploiement-item/$id';
  }
  static String cancelDelivery(int id) {
    return '$url/refused-deploiement-item/$id';
  }
 
  static const dashboad = '$url/dashbord-stat';
  

}

