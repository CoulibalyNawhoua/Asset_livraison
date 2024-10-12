import 'package:asset_managment_mobile_delivery/pages/compoments/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth.dart';
import '../../controllers/delivery.dart';
import '../../controllers/tournee.dart';
import '../compoments/card.dart';
import '../../constantes/constantes.dart';
import 'detail.dart';

class ListDeliveryPage extends StatefulWidget {
  final String uuid;
  const ListDeliveryPage({super.key, required this.uuid});

  @override
  State<ListDeliveryPage> createState() => _ListDeliveryPageState();
}

class _ListDeliveryPageState extends State<ListDeliveryPage> with TickerProviderStateMixin {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final DeliveryController deliveryController = Get.put(DeliveryController());
  final TourneeController tourneeController = Get.put(TourneeController());
  late TabController tabController;
 
 @override
  void initState() {
    super.initState();
      setState(() {
        authenticateController.checkAccessToken();
        tabController = TabController(length: 3, vsync: this); //3 onglets fixes
        deliveryController.fetchDeliveriesWaiting(widget.uuid);
        deliveryController.fetchDeliveriesCompleted(widget.uuid);
        deliveryController.fetchDeliveriesCanceled(widget.uuid);
      });
  }
  // Fonction pour générer des titres d'onglets dynamiques
    List<Tab> _generateTabs() {
      return [
        Tab(text: 'En cours (${deliveryController.deliverieWaiting.length})'),
        Tab(text: 'Terminées (${deliveryController.deliverieCompleted.length})'),
        Tab(text: 'Annulées (${deliveryController.deliverieCanceled.length})'),
      ];
    }
  

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CAppBarReturn(
        title: "Liste des livraisons", 
        onTap: (){authenticateController.deconnectUser();},
        onPressed: (){
          Get.back();
          deliveryController.fetchDeliveriesWaiting(widget.uuid);
          deliveryController.fetchDeliveriesCompleted(widget.uuid);
          deliveryController.fetchDeliveriesCanceled(widget.uuid);
          tourneeController.fetchTournee();
          deliveryController.fetchTotalAndPercentage();
        }
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mes livraisons",
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: AppColors.primaryColor),
            ),
            const SizedBox(height: 10.0,),
            Obx(() => TabBar(  // Mettre à jour la TabBar avec des titres dynamiques
              controller: tabController,
              tabs: _generateTabs(),
              labelColor: AppColors.secondaryColor,
              unselectedLabelColor: AppColors.primaryColor,
              indicatorColor: AppColors.secondaryColor,
              labelStyle: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
              labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            )),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  RefreshIndicator(
                    onRefresh: () async{deliveryController.fetchDeliveriesWaiting(widget.uuid);},
                    child: Obx(() {
                      if (deliveryController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (deliveryController.deliverieWaiting.isEmpty) {
                        return Center(child: Text('Aucune livraison en attente.',style: TextStyle(color: Colors.red),));
                      }

                      return ListView.builder(
                        itemCount: deliveryController.deliverieWaiting.length,
                        itemBuilder: (context, index) {
                          final deliveryWaiting = deliveryController.deliverieWaiting[index];
                          return PointDeVente(
                            nom: deliveryWaiting.dPdv,
                            adresse: deliveryWaiting.dAddresse,
                            numero: deliveryWaiting.dContact,
                            status: deliveryWaiting.status,
                            onpress: () {
                              print(deliveryWaiting.id);
                              Get.to(DetailPage(id: deliveryWaiting.id, uuid: widget.uuid));
                            },
                          );
                        },
                      );
                    }),
                  ),
                  RefreshIndicator(
                    onRefresh: () async{deliveryController.fetchDeliveriesCompleted(widget.uuid);},
                    child: Obx(() {
                      if (deliveryController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (deliveryController.deliverieCompleted.isEmpty) {
                        return Center(child: Text('Aucune livraison terminée.',style: TextStyle(color: Colors.red),));
                      }

                      return ListView.builder(
                        itemCount: deliveryController.deliverieCompleted.length,
                        itemBuilder: (context, index) {
                          final deliveryCompleted = deliveryController.deliverieCompleted[index];
                          return PointDeVente(
                            nom: deliveryCompleted.dPdv,
                            adresse: deliveryCompleted.dAddresse,
                            numero: deliveryCompleted.dContact,
                            status: deliveryCompleted.status,
                            onpress: () {
                              print(deliveryCompleted.id);
                              Get.to(DetailPage(id: deliveryCompleted.id, uuid: widget.uuid,));
                            },
                          );
                        },
                      );
                    }),
                  ),
                  RefreshIndicator(
                    onRefresh: () async{deliveryController.fetchDeliveriesCanceled(widget.uuid);},
                    child: Obx(() {
                      if (deliveryController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (deliveryController.deliverieCanceled.isEmpty) {
                        return Center(child: Text('Aucune livraison annulée.',style: TextStyle(color: Colors.red),));
                      } else {
                        return ListView.builder(
                          itemCount: deliveryController.deliverieCanceled.length,
                          itemBuilder: (context, index) {
                            final deliveryCanceled = deliveryController.deliverieCanceled[index];
                            return PointDeVente(
                              nom: deliveryCanceled.dPdv,
                              adresse: deliveryCanceled.dAddresse,
                              numero: deliveryCanceled.dContact,
                              status: deliveryCanceled.status,
                              onpress: () {
                                Get.to(DetailPage(id: deliveryCanceled.id, uuid: widget.uuid,));
                              },
                            );
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PointDeVenteCours  extends StatelessWidget {
  final String nom;
  final String adresse;
  final String numero;
  final VoidCallback onpress;

  const PointDeVenteCours ({
    super.key,
    required this.nom,
    required this.adresse,
    required this.numero,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
        child: Card(
          color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text("$nom - $numero",style: const TextStyle(fontSize: 14.0),),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.location_on_outlined,size: 10,),
                        Text(adresse,style: const TextStyle(fontSize: 10.0),),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 90,
                      height: 30,
                      child: ElevatedButton(
                      onPressed: null, 
                      style: ButtonStyle(
                        // backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Couleur du bouton
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                      child: const Text('Valider',style: TextStyle(fontSize: 12.0), )
                      )
                    ),
                  ),
                )
              ],
            ),
        ),
      
    );
  }
}


