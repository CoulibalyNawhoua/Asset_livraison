import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constantes/api.dart';
import '../models/Motif.dart';

class MotifController extends GetxController {
  final token = GetStorage().read("access_token");
  final isLoading = false.obs;

  RxList<Motif> motifs = <Motif>[].obs;

  
  Future<void> fetchMotif() async {
    try {
      isLoading.value = true;
      motifs.clear();
      var response = await http.get(Uri.parse(Api.listMotif), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data'];
        List<Motif> motifList = data.map((json) => Motif.fromJson(json)).toList();
        motifs.assignAll(motifList);
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des motifs");
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

  Future<void> anuuleLivraison(int motifId,int id) async {
    try {
      isLoading.value = true;
      var data = {
        'motif_id': motifId.toString(),
      };
      
      var response = await http.post(
        Uri.parse(Api.annulationLivraison(id)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        // var responseBody = jsonDecode(response.body);

        Get.snackbar(
          'Succès',
          'Livraison annulées avec succès',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

      } else {
        isLoading.value = false;
        Get.snackbar(
          'Erreur',
          'La livraison n\'a pas été annulées',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        if (kDebugMode) {
          print("Échec de la connexion");
        }

        if (kDebugMode) {
          print("Erreur lors de la récupération des motifs");
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

}