import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cartItems = [
    {
      "name": "Régime de Banane",
      "brand": "Maggi",
      "price": 15.30,
      "quantity": 2,
      "image": "assets/images/product.png",
    },
    {
      "name": "Feuille de laitue",
      "brand": "Maggi",
      "price": 12.00,
      "quantity": 2,
      "image": "assets/images/product.png",
    },
  ];

  double get _totalInitial {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item["price"] * item["quantity"]),
    );
  }

  int get _totalProducts {
    return _cartItems.fold(0, (int sum, item) => sum + (item["quantity"] as int));
  }

  final double _deliveryCost = 1.00;

  double get _total {
    return _totalInitial + _deliveryCost;
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
                // Titre avec flèche de retour
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.grey),
                    ),
                    const Text(
                      "Mon panier",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 20),

                // Liste des produits
                ..._cartItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> item = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(item["image"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nom + bouton supprimer
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item["name"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _cartItems.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                item["brand"],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grayColor,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "€${item["price"].toStringAsFixed(2)}/kg",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (item["quantity"] > 1) {
                                              item["quantity"]--;
                                            }
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        item["quantity"]
                                            .toString()
                                            .padLeft(2, '0'),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.grayColor,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            item["quantity"]++;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 20),

                // Résumé des coûts
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total initial",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "€${_totalInitial.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.grey.withOpacity(0.1), thickness: 1),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Coût de livraison",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "€${_deliveryCost.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.grey.withOpacity(0.1), thickness: 1),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total ($_totalProducts produit${_totalProducts > 1 ? 's' : ''})",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "€${_total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Bouton paiement
                 // Bouton Ajouter panier
                Center(
                  child: SizedBox(
                    width: 200, // 👈 Ajuste cette valeur si tu veux plus large
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(left: 0, right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                      label: const Text(
                        "Passez au paiement",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
