import 'package:flutter/material.dart';
import 'package:restoup_flutter/widget/brandScreen.dart';
import 'package:restoup_flutter/widget/categoryScreen.dart';
import 'package:restoup_flutter/widget/priceRangeScreen.dart';
import 'package:restoup_flutter/widget/sortScreen.dart';

// Convertir MySearchBAR en StatefulWidget pour gérer l'état des filtres
class MySearchBAR extends StatefulWidget {
  const MySearchBAR({super.key});

  @override
  State<MySearchBAR> createState() => _MySearchBARState();
}

class _MySearchBARState extends State<MySearchBAR> {
  String? selectedCategory;
  String? selectedSort;
  String? selectedBrand;
  String? selectedPriceRange;

  // Réinitialiser les filtres
  void resetFilters() {
    setState(() {
      selectedCategory = null;
      selectedSort = null;
      selectedBrand = null;
      selectedPriceRange = null;
    });
  }

  // Appliquer les filtres
  void applyFilters() {
    // Logique pour appliquer les filtres (par exemple, passer les valeurs à une API ou une liste de produits)
    print("Filtres appliqués : $selectedCategory, $selectedSort, $selectedBrand, $selectedPriceRange");
    Navigator.pop(context); // Fermer le BottomSheet après application
  }

  // Fonction pour gérer l'ouverture d'un BottomSheet et la récupération des valeurs sélectionnées
  Future<void> _showBottomSheetAndUpdateFilter(BuildContext context, Widget bottomSheetContent, String filterType) async {
    final result = await showModalBottomSheet<String?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => bottomSheetContent,
    );

    if (result != null) {
      setState(() {
        switch (filterType) {
          case 'category':
            selectedCategory = result;
            break;
          case 'sort':
            selectedSort = result;
            break;
          case 'brand':
            selectedBrand = result;
            break;
          case 'priceRange':
            selectedPriceRange = result;
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          // Section de recherche (icône + champ de texte) avec fond et bordure
          Expanded(
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Rechercher un produit",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Titre et icône de fermeture
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Filtres",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Option "Catégorie"
                            ListTile(
                              title: Text(
                                "Catégorie${selectedCategory != null ? ': $selectedCategory' : ''}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                              onTap: () {
                                Navigator.pop(context); // Ferme le BottomSheet des filtres
                                // Ouvre un nouveau BottomSheet pour les catégories
                                _showBottomSheetAndUpdateFilter(context, const CategoryScreen(), 'category');
                              },
                            ),

                            // Option "Trier"
                            ListTile(
                              title: Text(
                                "Trier${selectedSort != null ? ': $selectedSort' : ''}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                              onTap: () {
                                Navigator.pop(context);
                                _showBottomSheetAndUpdateFilter(context, const SortScreen(), 'sort');
                              },
                            ),

                            // Option "Marque"
                            ListTile(
                              title: Text(
                                "Marque${selectedBrand != null ? ': $selectedBrand' : ''}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                              onTap: () {
                                Navigator.pop(context);
                                _showBottomSheetAndUpdateFilter(context, const BrandScreen(), 'brand');
                              },
                            ),

                            // Option "Price Range"
                            ListTile(
                              title: Text(
                                "Price Range${selectedPriceRange != null ? ': $selectedPriceRange' : ''}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                              onTap: () {
                                Navigator.pop(context);
                                _showBottomSheetAndUpdateFilter(context, const PriceRangeScreen(), 'priceRange');
                              },
                            ),

                            const SizedBox(height: 20),

                            // Boutons "Réinitialiser" et "Appliquer"
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      resetFilters();
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "Réinitialiser",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      applyFilters();
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
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.grey,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}