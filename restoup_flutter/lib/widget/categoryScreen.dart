import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String? selectedCategory; // Variable pour suivre la catégorie sélectionnée

  // Liste des catégories (données statiques pour l'exemple)
  final List<String> categories = [
    'Produits frais',
    'Produits secs et épicerie',
    'Boissons',
    'Produits surgelés',
    'Produits de boulangerie et pâtisserie',
    'Matériel et consommables',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // Hauteur du BottomSheet (70% de l'écran)
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
                    "Catégorie",
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

          // Liste des catégories sous forme de puces arrondies
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10, // Espacement horizontal entre les puces
                runSpacing: 10, // Espacement vertical entre les lignes
                children: categories.map((category) {
                  bool isSelected = selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category; // Met à jour la catégorie sélectionnée
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.red : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
                  if (selectedCategory != null) {
                    Navigator.pop(context, selectedCategory); // Renvoyer la catégorie sélectionnée
                  }
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