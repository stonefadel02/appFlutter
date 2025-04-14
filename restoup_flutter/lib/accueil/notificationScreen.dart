import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre personnalisé avec flèche de retour et icône de panier
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context); // Retour à la page précédente
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      "Notification",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Naviguer vers la page du panier
                      },
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Section "Aujourd'hui"
                const Text(
                  "Aujourd'hui",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Notifications d'aujourd'hui
                _buildNotification(
                  icon: Icons.notifications,
                  title: "Notification de mise à jour",
                  description: "Ici que le texte et lorem consectetur in penatibus varius aliquet lorem",
                  time: "9min",
                  badgeCount: 2,
                ),
                const SizedBox(height: 20),
                _buildNotification(
                  icon: Icons.notifications,
                  title: "Notification de mise à jour",
                  description: "Ici que le texte et lorem consectetur in penatibus varius aliquet lorem",
                  time: "14min",
                  badgeCount: 0,
                ),

                const SizedBox(height: 30),

                // Section "Hier"
                const Text(
                  "Hier",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Notifications d'hier
                _buildNotification(
                  icon: Icons.notifications,
                  title: "Notification de mise à jour",
                  description: "Ici que le texte et lorem consectetur in penatibus varius aliquet lorem",
                  time: "14min",
                  badgeCount: 2,
                ),
                const SizedBox(height: 20),
                _buildNotification(
                  icon: Icons.notifications,
                  title: "Notification de mise à jour",
                  description: "Ici que le texte et lorem consectetur in penatibus varius aliquet lorem",
                  time: "14min",
                  badgeCount: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget pour une notification
  Widget _buildNotification({
    required IconData icon,
    required String title,
    required String description,
    required String time,
    required int badgeCount,
  }) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icône de notification
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF5E1), // Beige clair
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),

            // Détails de la notification
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Badge de notification en bas à droite
        if (badgeCount > 0)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}