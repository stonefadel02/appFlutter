import 'package:flutter/material.dart';

class SortScreen extends StatefulWidget {
  const SortScreen({super.key});

  @override
  State<SortScreen> createState() => _SortScreenState();
}

class _SortScreenState extends State<SortScreen> {
  String? selectedSort; // Variable pour suivre l'option de tri sélectionnée

  // Liste des options de tri
  final List<String> sortOptions = [
    'De A à Z',
    'De Z à A',
    'Prix/kg croissant',
    'Prix/kg décroissant',
    'Prix/L croissant',
    'Prix/L décroissant',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9, // Hauteur du BottomSheet (70% de l'écran)
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
                    "Filtre", // Titre "Filtre" comme dans la maquette
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

          // Liste des options de tri avec boutons/Ligne de séparation avec opacité et ombre
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < sortOptions.length; i++) ...[
                    RadioListTile<String>(
                      title: Text(
                        sortOptions[i],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      value: sortOptions[i],
                      groupValue: selectedSort,
                      onChanged: (String? value) {
                        setState(() {
                          selectedSort = value; // Met à jour l'option sélectionnée
                        });
                      },
                      activeColor: Colors.red, // Couleur du bouton radio sélectionné
                      controlAffinity: ListTileControlAffinity.leading, // Bouton radio à gauche
                    ),
                    // Ajouter une ligne de séparation avec opacité et ombre, sauf après la dernière option
                    if (i < sortOptions.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Marges horizontales
                        child: Container(
                          height: 1, // Hauteur de la ligne
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3), // Faible opacité
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2), // Ombre légère
                                blurRadius: 4, // Flou de l'ombre
                                offset: const Offset(0, 2), // Décalage de l'ombre
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
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
                  if (selectedSort != null) {
                    Navigator.pop(context, selectedSort); // Renvoyer l'option de tri sélectionnée
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