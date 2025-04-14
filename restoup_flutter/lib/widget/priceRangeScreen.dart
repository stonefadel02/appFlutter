import 'package:flutter/material.dart';

class PriceRangeScreen extends StatefulWidget {
  const PriceRangeScreen({super.key});

  @override
  State<PriceRangeScreen> createState() => _PriceRangeScreenState();
}

class _PriceRangeScreenState extends State<PriceRangeScreen> {
  RangeValues _priceRange = const RangeValues(100, 1500); // Valeurs initiales (100 à 1500 €/kg)

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9, // Hauteur du BottomSheet (90% de l'écran)
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // S'adapte à la taille du contenu
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre et icône de retour
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Ferme le BottomSheet sans sélection
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios, // Flèche de retour (vers la gauche)
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  const Text(
                    "Fourchette de prix", // Titre comme dans la maquette
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Valeur maximale affichée au-dessus du slider
          Center(
            child: Text(
              "1500€/kg", // Valeur maximale
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Slider pour la fourchette de prix
          RangeSlider(
            values: _priceRange,
            min: 100, // Valeur minimale
            max: 1500, // Valeur maximale
            divisions: 14, // Nombre de divisions (1500 - 100) / 100 = 14
            activeColor: Colors.yellow, // Couleur du slider actif (jaune comme dans la maquette)
            inactiveColor: Colors.grey[300], // Couleur du slider inactif
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values; // Met à jour la fourchette de prix
              });
            },
          ),

          // Affichage des valeurs sélectionnées
          Center(
            child: Text(
              "${_priceRange.start.round()}€/kg - ${_priceRange.end.round()}€/kg",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Bouton "Appliquer" (centré et moins long)
          Center(
            child: SizedBox(
              width: 200, // Largeur réduite pour le bouton
              child: ElevatedButton(
                onPressed: () {
                  // Renvoyer la fourchette de prix sous forme de chaîne
                  Navigator.pop(
                    context,
                    "${_priceRange.start.round()}€/kg - ${_priceRange.end.round()}€/kg",
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Appliquer",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}