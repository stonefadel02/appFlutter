import 'package:flutter/material.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  // Contrôleur pour le champ d'adresse
  final TextEditingController _addressController = TextEditingController(text: "Rue 235 Paris Westerlay");

  @override
  void dispose() {
    // Libérer le contrôleur
    _addressController.dispose();
    super.dispose();
  }

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
                      "Adresse de livraison",
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
                  "Actualisez votre adresse",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // Champ pour l'adresse avec fond gris
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    filled: true, // Activer le remplissage
                    fillColor: Colors.grey[200], // Fond gris clair
                    hintText: "Adresse",
                    border: InputBorder.none, // Pas de bordure
                    enabledBorder: InputBorder.none, // Pas de bordure en mode normal
                    focusedBorder: InputBorder.none, // Pas de bordure en mode focus
                    suffixIcon: const Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Bouton "Sauvegarder" sur toute la largeur
                SizedBox(
                  width: double.infinity, // Toute la largeur
                  child: ElevatedButton(
                    onPressed: () {
                      // Logique pour sauvegarder l'adresse
                      print("Adresse: ${_addressController.text}");
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