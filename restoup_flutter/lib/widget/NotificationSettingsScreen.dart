import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Variables pour suivre l'état des interrupteurs
  bool _generalNotification = true;
  bool _sound = true;
  bool _appUpdate = false;

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
                // Titre personnalisé avec flèche de retour
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
                    const SizedBox(width: 48), // Espace pour équilibrer la disposition
                  ],
                ),
                const SizedBox(height: 20),

                // Sous-titre
                const Text(
                  "Paramétrez votre notification",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // Option "Notification Général"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Notification Général",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: _generalNotification,
                      onChanged: (bool value) {
                        setState(() {
                          _generalNotification = value;
                        });
                      },
                      activeColor: Colors.yellow, // Couleur lorsque l'interrupteur est activé
                      inactiveThumbColor: Colors.grey, // Couleur lorsque l'interrupteur est désactivé
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Option "Son"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Son",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: _sound,
                      onChanged: (bool value) {
                        setState(() {
                          _sound = value;
                        });
                      },
                      activeColor: Colors.yellow, // Couleur lorsque l'interrupteur est activé
                      inactiveThumbColor: Colors.grey, // Couleur lorsque l'interrupteur est désactivé
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Option "Mise à jour de l'application"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Mise à jour de l'application",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: _appUpdate,
                      onChanged: (bool value) {
                        setState(() {
                          _appUpdate = value;
                        });
                      },
                      activeColor: Colors.yellow, // Couleur lorsque l'interrupteur est activé
                      inactiveThumbColor: Colors.grey, // Couleur lorsque l'interrupteur est désactivé
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Bouton "Sauvegarder" sur toute la largeur
                SizedBox(
                  width: double.infinity, // Toute la largeur
                  child: ElevatedButton(
                    onPressed: () {
                      // Logique pour sauvegarder les paramètres de notification
                      print("Notification Général: $_generalNotification");
                      print("Son: $_sound");
                      print("Mise à jour: $_appUpdate");
                      Navigator.pop(context); // Revenir à la page précédente après sauvegarde
                    },
                    child: const Text(
                      "Sauvegarder",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}