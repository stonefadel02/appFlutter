import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({super.key});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  String? selectedBrand; // Variable pour suivre la marque sélectionnée

  // Liste des marques
  final List<String> brands = [
    'Maggi',
    'Knorr',
    'Oreo',
    'Doritos',
    'Heinz',
    'Haricot',
  ];

  // Liste filtrée pour la recherche
  List<String> filteredBrands = [];

  @override
  void initState() {
    super.initState();
    filteredBrands =
        brands; // Initialiser la liste filtrée avec toutes les marques
  }

  // Fonction pour filtrer les marques en fonction de la recherche
  void filterBrands(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredBrands = brands;
      } else {
        filteredBrands =
            brands
                .where(
                  (brand) => brand.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height *
          0.9, // Hauteur du BottomSheet (90% de l'écran)
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
                      Navigator.pop(
                        context,
                      ); // Ferme le BottomSheet sans sélection
                    },
                    icon: const Icon(
                      Icons.arrow_back, // Flèche de retour (vers la gauche)
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  const Text(
                    "Marque", // Titre "Marque" comme dans la maquette
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10), // Réduit l'espacement
          // Champ de recherche
          Container(
            decoration: BoxDecoration(
              color: AppColors.grayColor.withOpacity(0.1), // Fond gris clair

              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      filterBrands(
                        value,
                      ); // Filtrer les marques en fonction de la saisie
                    },
                    decoration: const InputDecoration(
                      hintText: "Rechercher une marque",
                      hintStyle: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10), // Réduit l'espacement
          // Liste des marques avec boutons radio (avec défilement)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < filteredBrands.length; i++) ...[
                    RadioListTile<String>(
                      title: Text(
                        filteredBrands[i],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      value: filteredBrands[i],
                      groupValue: selectedBrand,
                      onChanged: (String? value) {
                        setState(() {
                          selectedBrand =
                              value; // Met à jour la marque sélectionnée
                        });
                      },
                      activeColor:
                          Colors.red, // Couleur du bouton radio sélectionné
                      controlAffinity:
                          ListTileControlAffinity
                              .leading, // Bouton radio à gauche
                    ),
                    // Ajouter une ligne de séparation avec opacité et ombre, sauf après la dernière option
                    if (i < filteredBrands.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ), // Marges horizontales
                        child: Container(
                          height: 1, // Hauteur de la ligne
                          decoration: BoxDecoration(
                            color: AppColors.grayColor.withOpacity(
                              0.1,
                            ), // Faible opacité
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 10), // Réduit l'espacement
          // Bouton "Appliquer" (centré et moins long)
          Center(
            child: SizedBox(
              width: 200, // Largeur réduite pour le bouton
              child: ElevatedButton(
                onPressed: () {
                  if (selectedBrand != null) {
                    Navigator.pop(
                      context,
                      selectedBrand,
                    ); // Renvoyer la marque sélectionnée
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
