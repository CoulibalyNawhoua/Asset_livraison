import 'package:asset_managment_mobile_delivery/fonctions/fonctions.dart';
import 'package:asset_managment_mobile_delivery/pages/compoments/appbar.dart';
import 'package:asset_managment_mobile_delivery/pages/compoments/select-input.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../constantes/api.dart';
import '../../controllers/auth.dart';
import '../../controllers/delivery.dart';
import '../../controllers/motif.dart';
import '../../constantes/constantes.dart';

class DetailPage extends StatefulWidget {
  final int id;
  final String uuid;
  const DetailPage({super.key, required this.id, required this.uuid});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final DeliveryController deliveryController = Get.put(DeliveryController());
  final MotifController motifController = Get.put(MotifController());
  

  double distanceM = 0;
  bool isWithinRange = false;
  bool isLoadingButtons = true;

  

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      calculateDistance();
      deliveryController.fetchDeliveryDetails(widget.id);
      motifController.fetchMotif(); 
    });
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          isLoadingButtons = false;
        });
      }
    });
  }

   // fonction de localisation d'un utilisateur
  Future<void> calculateDistance() async {
    // Demander les permissions de localisation
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Le service de localisation est désactivé.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Les permissions de localisation sont refusées');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Les permissions de localisation sont définitivement refusées, nous ne pouvons pas demander les permissions.');
    }

    // Obtenir la position actuelle de l'utilisateur
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Définir les coordonnées du point spécifique
      // Récupérer les détails de livraison
    final delivery = deliveryController.deliveryDetails.value;
    if (delivery == null) {
      return Future.error('Aucun détail de livraison trouvé');
    }
    // Extraire les coordonnées du point spécifique
    double pointLatitude = double.parse(delivery.dLatitude);
    double pointLongitude = double.parse(delivery.dLongitude);

    // double pointLatitude = 5.3862285;
    // double pointLongitude = -3.9827405;
 
    // Calculer la distance entre la position actuelle et le point spécifique en mètre
    double distanceMm = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      // pointLatitude,
      // pointLongitude,
      position.latitude,
      position.longitude,
    );

    // Calculer la distance en mètres
     // Conserver la distance en mètres et vérifier si l'utilisateur est à moins de 10 mètres
    // double _distanceKm = distanceMm / 1000;

    if (mounted) {
      setState(() {
      distanceM = distanceMm;
      isWithinRange = distanceM <= 200;
      });
    }
  }

  void showCodeDialog(int id) {
    final TextEditingController codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: Text("Voulez-vous valider cette livraison ?"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('Annuler',style: TextStyle(color: Colors.black),),
                  onPressed: () {
                    Navigator.of(context).pop(dialogContext);
                    codeController.clear();
                  },
                ),
                TextButton(
                  child: Text('Confirmer',style: TextStyle(color: Colors.green),),
                  onPressed: () async{
                    print(widget.id);
                    // var code_livraison = codeController.text;
                    await deliveryController.confirmeDelivery(widget.id);
                    await deliveryController.fetchDeliveryDetails(widget.id);
                    Navigator.of(context).pop(dialogContext);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void showCancelDialog(int id) {
    String? motifValue = "-1";
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.white,
          title: Text("Voulez-vous annuler cette livraison ?",style: TextStyle(fontSize: 16)),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  if (motifController.isLoading.value) {
                    return CircularProgressIndicator();
                  } else if (motifController.motifs.isEmpty) {
                    return Text("Aucun motif disponible");
                  } else {
                    return SelectInput(
                      value: motifValue, 
                      items: [
                        const DropdownMenuItem(
                          value: "-1",
                          child: Text("Sélectionnez un motif"),
                        ),
                        ...motifController.motifs.map((motif) {
                          return DropdownMenuItem(
                            value: motif.id.toString(),
                            child: Text(motif.libelle),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                           motifValue = value;
                        });
                      }, 
                      hint: "Sélectionnez un motif", 
                      validator: (value) {
                          if (value == "-1" || value == null) {
                            return "Veuillez sélectionner un motif";
                          }
                        return null;
                      },
                    );
                  }
                }),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text("Non", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Oui", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  onPressed: () async { 
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      // inspect(int.parse(motifValue!));
                      await motifController.anuuleLivraison(int.parse(motifValue!),widget.id);
                      await deliveryController.fetchDeliveryDetails(widget.id);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CAppBarReturn(
        title: "Détails de la livraison",
        onPressed: (){
          Get.back();
          deliveryController.fetchDeliveriesWaiting(widget.uuid);
          deliveryController.fetchDeliveriesCanceled(widget.uuid);
          deliveryController.fetchDeliveriesCompleted(widget.uuid);
          deliveryController.fetchTotalAndPercentage();
        },
        onTap: (){authenticateController.deconnectUser();},
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Obx(() {
            if (deliveryController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              final delivery = deliveryController.deliveryDetails.value;
              if (delivery == null) {
                return Center(child: Text("Aucun détail de livraison trouvé", style: TextStyle(color: Colors.red),));
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(delivery.status == 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        icon(() { openMap(double.parse(delivery.dLatitude), double.parse(delivery.dLongitude));}),
                        isLoadingButtons
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      width: 100,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  Text("Valider",),
                                ],
                              )
                            : ElevatedButton(
                                onPressed: isWithinRange
                                  ? () {
                                      showCodeDialog(delivery.id);
                                    }
                                  : null,
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    isWithinRange ? Colors.green : Colors.grey.shade300,
                                  ),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: Text("Valider"),
                              ),
                        isLoadingButtons
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      width: 100,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  Text("Annuler",),
                                ],
                              )
                            : ElevatedButton(
                                onPressed: isWithinRange
                                  ? () {
                                      showCancelDialog(delivery.id);
                                    }
                                  : null,
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    isWithinRange ? Colors.red : Colors.grey.shade300,
                                  ),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: Text("Annuler"),
                              ),
                      ],
                    ),
                    const SizedBox(height: 15.0,),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0),),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Informations sur la tournée",style: TextStyle(fontWeight: FontWeight.bold),),
                          const SizedBox(height: 20.0,),
                          buildRowItem("Code de la tournée:", delivery.tournee.code),
                          const SizedBox(height: 10.0,),
                          buildRowItem("Matricule du vehicule:", delivery.tournee.vehicule.matricule),
                          const SizedBox(height: 10.0,),
                          buildRowItemStatus("Status", delivery.status),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(top: 30.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0),),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Informations sur l'affectation",style: TextStyle(fontWeight: FontWeight.bold),),
                          const SizedBox(height: 20.0,),
                          buildRowItem("Code affectation:", delivery.affect.code),
                          const SizedBox(height: 10.0,),
                          buildRowItem("Nom du pdv:", delivery.dPdv),
                          const SizedBox(height: 10.0,),
                          buildRowItem("Contact du pdv:", delivery.dContact),
                          const SizedBox(height: 10.0,),
                          buildRowItem("Adresse du pdv:", delivery.dAddresse),
                          const SizedBox(height: 10.0,),
                          buildRowItem("Date de validation:", delivery.dateValidation != null ? DateFormat('dd MMM yyyy HH:mm').format(delivery.dateValidation!) : "Inconnu"),
                          const SizedBox(height: 10.0,),
                          buildRowItem("Territoire:", delivery.dTerritoire),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(top: 30.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0),),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Informations du matériel",style: TextStyle(fontWeight: FontWeight.bold),),
                          const SizedBox(height: 20.0,),
                          buildRowItem("Materiel:", delivery.affect.materiel.materielForDeploy.libelle),
                          const SizedBox(height: 10.0,),
                          buildRowItem("Numero de série:", delivery.affect.materiel.numSerie),
                          const SizedBox(height: 10.0,),
                          buildRowItem("Marque du materiel:", delivery.affect.materiel.materielForDeploy.marque.libelle),
                          const SizedBox(height: 10.0,),
                          buildRowItem("Model du materiel:", delivery.affect.materiel.materielForDeploy.modele.libelle),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }
          }),
        ),
      ),
    );
  }

  Widget texButom(String title) {
    return ElevatedButton(
      onPressed: null,
      style: ButtonStyle(
        // backgroundColor: MaterialStateProperty.all<Color>(color), // Couleur du bouton
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
      child: Text(title,style: const TextStyle(fontSize: 12.0), )
    );
  }

  Widget icon(VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed, 
      icon: const Icon(
        Icons.location_on,
        color: Colors.blue,
        size: 30.0,

      )
    );
  }

  Widget buildRowItem(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Row buildRowItemStatus(String title, int value) {
    String statusText;
    Color statusColor;

    switch (value) {
      case 1:
        statusText = "Livré";
        statusColor = Colors.green;
        break;
      case 3:
        statusText = "Rejétée";
        statusColor = Colors.red;
        break;
      default:
        statusText = "En attente";
        statusColor = Colors.yellow.shade900;
        break;
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          statusText,
          style: TextStyle(color: statusColor),
        )
      ],
    );
  }

  Widget buildRowItemImage(String title, String image) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        image.isNotEmpty
          ? Image.network(
              "${Api.imageUrl}${image}",
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )
          : Text('Image non disponible'),
        // Image.network(
        //   // image,
        //   "${Api.imageUrl}${image}",
        //   height: 100,
        //   width: 100,
        //   fit: BoxFit.cover,
        // )
      ],
    );
  }
}


