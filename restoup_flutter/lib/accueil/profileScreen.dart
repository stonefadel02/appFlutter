import 'package:flutter/material.dart';
import 'package:restoup_flutter/accueil/PrivacyPolicyScreen.dart';
import 'package:restoup_flutter/accueil/editProfile.dart';
import 'package:restoup_flutter/widget/NotificationSettingsScreen.dart';
import 'package:restoup_flutter/widget/deliveryAddressScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // En-tête avec fond jaune
              Container(
                color: const Color(0xFFFFD700), // Jaune
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    // Flèche de retour
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context); // Retour à la page précédente
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Image de profil
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/profile.png"), // Remplace par le chemin de ton image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Nom de l'utilisateur
                    const Text(
                      "Jean BlackJack",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    // Adresse e-mail
                    const Text(
                      "jeanblackjack@gmail.com",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              // Liste des options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
                  children: [
                    _buildOption(
                      icon: Icons.person,
                      title: "Votre Profil",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildOption(
                      icon: Icons.location_on,
                      title: "Adresse de livraison",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DeliveryAddressScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildOption(
                      icon: Icons.notifications,
                      title: "Notification",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildOption(
                      icon: Icons.lock,
                      title: "Sécurité",
                      onTap: () {
                        // Naviguer vers la page de sécurité
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildOption(
                      icon: Icons.privacy_tip,
                      title: "Politique et Confidentialité",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 40),

                    // Bouton "Déconnexion" avec boîte de dialogue
                    SizedBox(
                      width: 200, // Largeur réduite
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Afficher la boîte de dialogue de confirmation
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                "Déconnexion",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text(
                                "Êtes-vous sûr de vouloir vous déconnecter ?",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Fermer la boîte de dialogue
                                  },
                                  child: const Text(
                                    "Annuler",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Logique pour la déconnexion
                                    Navigator.pop(context); // Fermer la boîte de dialogue
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Se déconnecter",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          "Déconnexion",
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
            ],
          ),
        ),
      ),
    );
  }

  // Widget pour une option
  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }
}

// Placeholder pour la page de connexion (à remplacer par ta vraie page de connexion)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text("Page de connexion"),
      ),
    );
  }
}