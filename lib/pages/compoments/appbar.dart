import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import '../../controllers/auth.dart';
import '../../constantes/constantes.dart';
import '../../controllers/notification.dart';
import '../../fonctions/fonctions.dart';

class CAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String name;

  const CAppBarHome({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {

    final AuthenticateController authenticateController = Get.put(AuthenticateController());
    final NotificationController notificationController = Get.put(NotificationController());
    
    const int notificationCount = 15;
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          child: CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: Text(
              getInitials(name),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      actions: [
        Obx(() => badges.Badge(
          showBadge: notificationController.notificationCount.value > 0,
          badgeContent: Text(
            '${notificationController.notificationCount}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.red,
            padding: EdgeInsets.all(3),
          ),
          position: badges.BadgePosition.topEnd(top: 5, end: 5),
          child: IconButton(
            icon: const Icon(
              Icons.notifications,
              color: AppColors.primaryColor,
            ),
            onPressed: () {
              // Action lorsque l'icône de notification est pressée
              notificationController.showNotification();
            },
          ),
        )),
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          onPressed: () {authenticateController.deconnectUser();},
          
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onPressed;

  const CAppBar({
    super.key,
    required this.title,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          onPressed: onPressed,
        ),
      ],
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CAppBarReturn extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onPressed;
  final VoidCallback onTap;

  const CAppBarReturn({
    super.key,
    required this.title,
    required this.onPressed,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leading: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back,color: AppColors.primaryColor,),
            onPressed: onPressed,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          onPressed: onTap,
        ),
      ],
      
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
