import 'package:asset_managment_mobile_delivery/pages/compoments/appbar.dart';
import 'package:asset_managment_mobile_delivery/constantes/constantes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../controllers/auth.dart';
import '../controllers/delivery.dart';
import '../controllers/notification.dart';
import '../controllers/tournee.dart';
import '../models/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthenticateController authenticateController = Get.put(AuthenticateController());
  final DeliveryController deliveryController = Get.put(DeliveryController());
  final TourneeController tourneeController = Get.put(TourneeController());
  final NotificationController notificationController = Get.put(NotificationController());

  User? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticateController.checkAccessToken();
      deliveryController.fetchTotalAndPercentage();
      tourneeController.fetchTotal();
      getUserData();
      
    });
  }

  Future<void> getUserData() async {
    var userData = GetStorage().read<Map<String, dynamic>>("user");
    if (userData != null) {
      setState(() {
        user = User.fromJson(userData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CAppBarHome(name: user != null ? user!.useNom + ' ' + user!.usePrenom : "John Doe",),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text(
                //   "Dashboard",
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 20,
                //   ),
                // ),
                SizedBox(height: 20.0,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double itemWidth = (constraints.maxWidth - 40) / 2; // 20 spacing on both sides
                          return Obx(() => Wrap(
                            spacing: 20.0,
                            runSpacing: 20.0,
                            children: [
                              _buildGridItem(
                                "Livraisons totales",
                                deliveryController.percentages['total'] ?? 0.0.obs,
                                deliveryController.deploiementAffectTotal,
                                Colors.blue.shade100,
                                itemWidth,
                              ),
                              _buildGridItem(
                                "Livraisons terminées",
                                deliveryController.percentages['termine'] ?? 0.0.obs,
                                deliveryController.deploiementAffectSucces,
                                Colors.green.shade100,
                                itemWidth,
                              ),
                              _buildGridItem(
                                "Livraisons en cours",
                                deliveryController.percentages['attente'] ?? 0.0.obs,
                                deliveryController.deploiementAffectEncours,
                                Colors.yellow.shade100,
                                itemWidth,
                              ),
                              _buildGridItem(
                                "Livraisons annulées",
                                deliveryController.percentages['rejet'] ?? 0.0.obs,
                                deliveryController.deploiementAffectEchec,
                                Colors.red.shade100,
                                itemWidth,
                              ),
                            ],
                          ));
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0,),
                ListTile(
                  title: Text("Nombre total des tournées:"),
                  trailing: Obx(() =>  Text("${tourneeController.tourneeAffectTotal.value}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(String title, RxDouble percentage, RxInt total,Color color, double width) {
    return Container(
      width: width,
      height: 200,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Obx(() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10.0),
          CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 10.0,
            percent: percentage.value,
            animation: true,
            animationDuration: 500,
            center: Text(
              "${(percentage.value * 100).toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            progressColor: Colors.blue,
            circularStrokeCap: CircularStrokeCap.butt,
          ),
          const SizedBox(width: 10.0),
          Text(
            "Total: ${total.value}",
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
        ],
      )),
    );
  }
}

