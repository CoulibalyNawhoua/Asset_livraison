import 'package:asset_managment_mobile_delivery/pages/compoments/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/auth.dart';
import '../../controllers/tournee.dart';
import '../../constantes/constantes.dart';
import '../livraison/list.dart';

class ListTournePage extends StatefulWidget {
  const ListTournePage({super.key});

  @override
  State<ListTournePage> createState() => _ListTournePageState();
}

class _ListTournePageState extends State<ListTournePage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final TourneeController tourneeController = Get.put(TourneeController());
  

    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      tourneeController.fetchTournee();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CAppBar(title: "Liste des tournées",onPressed: (){authenticateController.deconnectUser();},),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text("Mes Tournées",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: AppColors.primaryColor),),
            const SizedBox(height: 10.0,),
            Expanded(
              child: Obx(() {
                if (tourneeController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (tourneeController.tournees.isEmpty) {
                  return Center(child: Text('Aucune tournée disponible.',style: TextStyle(color: Colors.red),));
                } else {
                  return RefreshIndicator(
                    onRefresh: () async{tourneeController.fetchTournee();},
                    child: ListView.builder(
                      itemCount: tourneeController.tournees.length,
                      itemBuilder: (context, index) {
                        final tourne = tourneeController.tournees[index];
                        return TourneItem(
                          code: tourne.code,
                          date: tourne.date,
                          nbreDeploiement: tourne.deploiementsCount,
                          status: tourne.status,
                          onPressed: () {
                            print(tourne.uuid);
                            Get.to(ListDeliveryPage(uuid: tourne.uuid));
                          },
                        );
                      },
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  
}

class TourneItem extends StatelessWidget {
  final String code;
  final DateTime date;
  final int nbreDeploiement;
  final int status;
  final VoidCallback onPressed;

  const TourneItem ({
    super.key,
    required this.code,
    required this.date,
    required this.nbreDeploiement,
    required this.status,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;

    switch (status) {
      case 1:
        statusText = "Livré";
        statusColor = Colors.green;
        break;
      case 2:
        statusText = "Annulé";
        statusColor = Colors.red;
        break;
      default:
        statusText = "En attente";
        statusColor = Colors.yellow.shade900;
        break;
    }
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(code),
                      subtitle: Text("Livraisons:${nbreDeploiement.toString()}",style: const TextStyle(fontSize: 12.0),),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(statusText,style: TextStyle( color: statusColor)),
                      subtitle: Text(DateFormat('dd MMMM yyyy','fr_FR').format(date),style: TextStyle(fontSize: 12.0),),
                       
                    ),
                  ),
                  // const Icon(Icons.navigate_next),
                ],
              ),
              const Divider(height: 1, thickness: 1,),
            ],
          ),
      ),
    );
  }
}


