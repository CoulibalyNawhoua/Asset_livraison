import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constantes/api.dart';
import '../models/Tournee.dart';

class TourneeController extends GetxController {
  final token = GetStorage().read("access_token");
  final isLoading = false.obs;

  RxList<Tournees> tournees = <Tournees>[].obs;
  RxInt tourneeAffectTotal = 0.obs;

  
  Future<void> fetchTournee() async {
    try {
      isLoading.value = true;
      tournees.clear();
      var response = await http.get(Uri.parse(Api.listTournee), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data'];
        List<Tournees> tourneeList = data.map((json) => Tournees.fromJson(json)).toList();
        tournees.assignAll(tourneeList);
        // inspect(tourneeList);
        // inspect(tournees);
      } else {
        isLoading.value = false;

        if (kDebugMode) {
          print("Erreur lors de la récupération des tournées");
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

    Future<void> fetchTotal() async {
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

        tourneeAffectTotal.value = responseBody['tournee_affect_total'];
      
      } else {
        isLoading.value = false;
        print('Erreur lors de la récupération des résumés de tournés');
      }
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
      } 
    }
  }

}