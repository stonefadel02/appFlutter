import 'package:flutter/material.dart';
import 'package:restoup_flutter/accueil/trackingScreen.dart';
import 'package:restoup_flutter/widget/cancelPopup.dart';
import 'package:restoup_flutter/widget/detailsPopup.dart';

class Commandes extends StatefulWidget {
  const Commandes({super.key});

  @override
  State<Commandes> createState() => _CommandesState();
}

class _CommandesState extends State<Commandes> {
  // Liste fictive des commandes pour l'exemple, avec une liste de produits
  List<Map<String, dynamic>> orders = [
    {
      'amount': '€33,60',
      'date': '12/04/2025',
      'time': 'à 14H03',
      'deliveryTime': '25 min',
      'productCount': '2 Produits commandés',
      'products': [
        {
          'name': 'Régime de banane Maggi',
          'quantity': '2',
          'price': '€16',
          'weight': '30g',
        },
        {
          'name': 'Régime de banane Maggi',
          'quantity': '2',
          'price': '€16',
          'weight': '30g',
        },
      ],
    },
    {
      'amount': '€33,60',
      'date': '12/04/2025',
      'time': 'à 14H03',
      'deliveryTime': '25 min',
      'productCount': '2 Produits commandés',
      'products': [
        {
          'name': 'Régime de banane Maggi',
          'quantity': '2',
          'price': '€16',
          'weight': '30g',
        },
        {
          'name': 'Régime de banane Maggi',
          'quantity': '2',
          'price': '€16',
          'weight': '30g',
        },
      ],
    },
  ];

  // Variable pour gérer l'état du soulignement de "Détail" pour chaque commande
  List<bool> isDetailPressedList = [];

  @override
  void initState() {
    super.initState();
    // Initialiser la liste des états de soulignement (une pour chaque commande)
    isDetailPressedList = List<bool>.filled(orders.length, false);
  }

  // Fonction pour annuler une commande
  void _cancelOrder(int index, String reason) {
    setState(() {
      orders.removeAt(index); // Supprime la commande de la liste
      isDetailPressedList.removeAt(index); // Met à jour la liste des états de soulignement
    });
    // Affiche une confirmation (facultatif)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Commande annulée avec succès. Raison : $reason"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // En-tête
      appBar: AppBar(
        title: const Text(
          "Mes Commandes",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Centre le titre
        actions: [
          IconButton(
            onPressed: () {
              // Action pour ouvrir le panier
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),

      // Corps de la page (liste des commandes)
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ligne 1 : "Montant de la commande" et Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Montant de la commande",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        order['date'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Ligne 2 : Montant en chiffres et Heure
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order['amount'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        order['time'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Ligne 3 : "Temps d’arrivée" et "Détail"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Temps d’arrivée",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            isDetailPressedList[index] = true; // Activer le soulignement
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            isDetailPressedList[index] = false; // Désactiver le soulignement
                          });
                          // Ouvre le popup avec les détails des produits
                          showDialog(
                            context: context,
                            builder: (context) => OrderDetailsPopup(
                              products: order['products'],
                            ),
                          );
                        },
                        onTapCancel: () {
                          setState(() {
                            isDetailPressedList[index] = false; // Désactiver le soulignement
                          });
                        },
                        child: Text(
                          "Détail",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            decoration: isDetailPressedList[index]
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Ligne 4 : Nombre de minutes et "2 Produits commandés"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order['deliveryTime'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        order['productCount'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ligne 5 : Boutons "Annuler" et "Suivi commande"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Ouvre le popup pour demander la raison de l'annulation
                            showDialog(
                              context: context,
                              builder: (context) => CancelReasonPopup(
                                onSubmit: (reason) {
                                  _cancelOrder(index, reason); // Annule la commande
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Annuler",
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
                            // Naviguer vers la page de suivi de commande
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OrderTrackingScreen(
                                  trackingSteps: null,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Suivi commande",
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
            ),
          );
        },
      ),

      // Barre de navigation inférieure (inchangée)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // "Commandes" est sélectionné
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Commandes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoris",
          ),
        ],
        onTap: (index) {
          // Gérer la navigation entre les pages
          if (index == 0) {
            // Naviguer vers la page d'accueil
          } else if (index == 2) {
            // Naviguer vers la page des favoris
          }
        },
      ),
    );
  }
}