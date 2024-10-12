import 'package:flutter/material.dart';

class PointDeVente  extends StatelessWidget {
  final String nom;
  final String adresse;
  final String numero;
  final int status;
  final VoidCallback onpress;

  const PointDeVente ({
    super.key,
    required this.nom,
    required this.adresse,
    required this.numero,
    required this.status,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {

    String statusText;
    Color statusColor;

    switch (status) {
      case 1:
        statusText = "Terminée";
        statusColor = Colors.green;
        break;
      case 3:
        statusText = "Rejétée";
        statusColor = Colors.red;
        break;
      case 4:
        statusText = "Reprogrammé";
        statusColor = Colors.red;
        break;
      default:
        statusText = "En attente";
        statusColor = Colors.yellow.shade900;
        break;
    }
    return GestureDetector(
      onTap: onpress,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text("$nom - $numero",style: const TextStyle(fontSize: 14.0),),
              subtitle: Row(
                children: [
                  const Icon(Icons.location_on_outlined,size: 10,),
                  Text(adresse,style: const TextStyle(fontSize: 10.0),),
                ],
              ),
              trailing: Text(
                statusText,
                style: TextStyle(
                  fontSize: 12.0,
                  color: statusColor,
                ), 
              )
            ),
            const Divider(height: 1, thickness: 1,),
          ],
        ),
      ),
    );
  }
}
