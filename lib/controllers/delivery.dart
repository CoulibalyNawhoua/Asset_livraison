import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constantes/api.dart';
import '../models/Delivery.dart';

class DeliveryController extends GetxController {

  final token = GetStorage().read("access_token");
  final isLoading = false.obs;

  RxList<Delivery> deliverieWaiting = <Delivery>[].obs;
  RxList<Delivery> deliverieCompleted = <Delivery>[].obs;
  RxList<Delivery> deliverieCanceled = <Delivery>[].obs;
  Rx<DeliveryDetail?> deliveryDetails = Rx<DeliveryDetail?>(null);
  RxMap<String, RxDouble> percentages = <String, RxDouble>{}.obs;
  RxInt deploiementAffectTotal = 0.obs;
  RxInt deploiementAffectSucces = 0.obs;
  RxInt deploiementAffectEncours = 0.obs;
  RxInt deploiementAffectEchec = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchTotalAndPercentage();
  }
  

  Future<void> fetchDeliveriesWaiting(String uuid) async {
    try {
      isLoading.value = true;
      deliverieWaiting.clear();
      var response = await http.get(Uri.parse(Api.deliveryWaiting(uuid)), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data'];
        List<Delivery> deliveryWaitingList = data.map((json) => Delivery.fromJson(json)).toList();
        deliverieWaiting.assignAll(deliveryWaitingList);
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des livraisons en attentes");
        }

        if (kDebugMode) {
          print(json.decode(response.body));
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDeliveriesCompleted(String uuid) async {
    try {
      isLoading.value = true;
      deliverieCompleted.clear();
      var response = await http.get(Uri.parse(Api.deliveryCompleted(uuid)), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data'];
        List<Delivery> deliveryCompletedList = data.map((json) => Delivery.fromJson(json)).toList();
        
        deliverieCompleted.assignAll(deliveryCompletedList);
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des livraisons terminées");
        }

        if (kDebugMode) {
          print(json.decode(response.body));
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDeliveriesCanceled(String uuid) async {
    try {
      isLoading.value = true;
      deliverieCanceled.clear();
      var response = await http.get(Uri.parse(Api.deliveryCanceled(uuid)), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data'];
        List<Delivery> deliveryCanceledList = data.map((json) => Delivery.fromJson(json)).toList();
        
        deliverieCanceled.assignAll(deliveryCanceledList);
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des livraisons annulées");
        }

        if (kDebugMode) {
          print(json.decode(response.body));
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDeliveryDetails(int id) async {
    try {
    isLoading.value = true;
    var response = await http.get(
      Uri.parse(Api.deliveryDetails(id)),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      isLoading.value = false;
      var responseBody = jsonDecode(response.body);
      var deliveryData = responseBody['data'];
      // inspect(deliveryData);
      
      if (deliveryData != null) { 
        deliveryDetails.value = DeliveryDetail.fromJson(deliveryData);
      } else {
        print('Données de livraison nulles');
      }
    } else {
      print('Erreur lors de la récupération des détails de la livraison');
    }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> valideDelivery(int id) async {
    try {
    isLoading.value = true;
    var response = await http.get(
      Uri.parse(Api.valideDelivery(id)),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      isLoading.value = false;
      Get.snackbar(
        'Succès',
        'Livraison validée avec succès!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await fetchDeliveryDetails(id);
    } else {
      print('Erreur lors de la validation de la livraison');
       print(response.body);
    }
    } catch (e) {
      print('Exception lors de la validation de la livraison: $e');
    } 
  }

  Future<void> canceledDelivery(int id) async {
    try {
    isLoading.value = true;
    var response = await http.get(
      Uri.parse(Api.cancelDelivery(id)),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      isLoading.value = false;
      Get.snackbar(
        'Succès',
        'Livraison annulée avec succès!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await fetchDeliveryDetails(id);
    } else {
      print('Erreur lors de la validation de la livraison');
       print(response.body);
    }
    } catch (e) {
      print('Exception lors de la validation de la livraison: $e');
    } 
  }

  Future<void> confirmeDelivery(int deploiementId) async {
    try {

      isLoading.value = true;
      
      var response = await http.get(
        Uri.parse(Api.confirmationLivraison(deploiementId)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );


      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);

        if (responseBody["code"] == 400) {
          Get.snackbar(
            'Echec',
            responseBody["msg"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }else{
          Get.snackbar(
            'Succès',
            'Livraison validée avec succès',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Erreur',
          'La livraison n\'a pas été validée',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        if (kDebugMode) {
          print("Échec");
        }

        if (kDebugMode) {
          print("Erreur lors de la validation");
        }

        if (kDebugMode) {
          print(json.decode(response.body));
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }
 
  Future<void> fetchTotalAndPercentage() async {
    try {
      isLoading.value = true;
      var response = await http.get(
        Uri.parse(Api.dashboad),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        
        isLoading.value = false;
        var responseBody = jsonDecode(response.body)["data"];

        deploiementAffectTotal.value = responseBody['deploiement_affect_total'];
        deploiementAffectSucces.value = responseBody['deploiement_affect_succes'];
        deploiementAffectEncours.value = responseBody['deploiement_affect_encours'];
        deploiementAffectEchec.value = responseBody['deploiement_affect_echec'];

        if (deploiementAffectTotal.value > 0) {
          percentages['termine'] = (deploiementAffectSucces.value / deploiementAffectTotal.value).obs;
          percentages['rejet'] = (deploiementAffectEchec.value / deploiementAffectTotal.value).obs;
          percentages['attente'] = (deploiementAffectEncours.value / deploiementAffectTotal.value).obs;
          percentages['total'] = 1.0.obs; // Le pourcentage total est toujours 100% sous forme de fraction
        } else {
          percentages['total'] = 0.0.obs;
          percentages['termine'] = 0.0.obs;
          percentages['rejet'] = 0.0.obs;
          percentages['attente'] = 0.0.obs;
        }
       
      } else {
        isLoading.value = false;
        print('Erreur lors de la récupération des résumés de livraison');
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      } 
    }
  }
  

}