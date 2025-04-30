import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restoup_flutter/accueil/commandes.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/widget/cart_manager.dart';
import 'package:restoup_flutter/services/api_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  final double _deliveryCost = 1.00;
  bool _isLoading = true;
  final ApiService apiService = ApiService();
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  // Charger les éléments du panier une seule fois au démarrage
  Future<void> _loadCartItems() async {
    final items = await CartManager().getCartItems();
    setState(() {
      _cartItems = items;
      _isLoading = false;
    });
  }

  // Extraire le prix unitaire de la chaîne (ex: "€15.30/kg" -> 15.30)
  double _extractUnitPrice(String priceString) {
    final pricePart = priceString.split('/')[0].replaceAll('€', '');
    return double.tryParse(pricePart) ?? 0.0;
  }

  // Calculer le prix total d'un produit (prix unitaire * quantité)
  String _calculateItemTotalPrice(Map<String, dynamic> item) {
    final unitPrice = _extractUnitPrice(item["price"]);
    final totalPrice = unitPrice * item["quantity"];
    final unit = item["price"].split('/')[1];
    return '€${totalPrice.toStringAsFixed(2)}/$unit';
  }

  // Calculer le total initial (somme des prix * quantités)
  double get _totalInitial {
    return _cartItems.fold(0, (sum, item) {
      final price = _extractUnitPrice(item["price"]);
      return sum + (price * item["quantity"]);
    });
  }

  // Calculer le nombre total de produits
  int get _totalProducts {
    return _cartItems.fold(
      0,
      (int sum, item) => sum + (item["quantity"] as int),
    );
  }

  // Calculer le prix total (total initial + frais de livraison)
  double get _total {
    return _totalInitial + _deliveryCost;
  }

  // Supprimer un élément du panier
  Future<void> _removeItem(int index) async {
    await CartManager().removeFromCart(index);
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  // Vérifier l'état de la commande via polling
  Future<bool> _pollOrderStatus(String orderId) async {
    const maxAttempts = 30; // Maximum 30 tentatives (30 * 2 secondes = 1 minute)
    int attempts = 0;

    while (attempts < maxAttempts) {
      try {
        final orderDetails = await apiService.getOrderDetails(orderId);
        final status = orderDetails['data']['order']['status'];

        print('Statut de la commande $orderId : $status');

        if (status == 'PENDING') {
          return true; // Paiement réussi
        } else if (status == 'CANCELLED') {
          return false; // Paiement échoué
        }

        // Attendre 2 secondes avant de réessayer
        await Future.delayed(Duration(seconds: 2));
        attempts++;
      } catch (e) {
        print('Erreur lors de la vérification du statut de la commande: $e');
        return false;
      }
    }

    // Si aucune réponse après maxAttempts, considérer comme échoué
    return false;
  }

  // Créer une commande et initier le paiement Stripe
  Future<void> _createOrder() async {
    try {
      setState(() {
        _isLoading = true; // Afficher un indicateur de chargement
      });

      // 1. Créer la commande
      final items = _cartItems.map((item) {
        return {
          'productVariantId': item['productVariantId'],
          'quantity': item['quantity'],
        };
      }).toList();

      final orderResponse = await apiService.createOrder(items);
      final orderId = orderResponse['data']['orderId'];
      print('Commande créée avec succès : $orderId');

      // 2. Créer un PaymentIntent
      final paymentIntentResponse = await apiService.createPaymentIntent(orderId, _total);
      final clientSecret = paymentIntentResponse['data']['clientSecret'];

      if (clientSecret == null) {
        throw Exception('Client secret manquant dans la réponse du PaymentIntent');
      }

      // 3. Initialiser le PaymentSheet avec le clientSecret
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'RestoUp',
          style: ThemeMode.system,
        ),
      );

      // 4. Afficher le PaymentSheet
      await Stripe.instance.presentPaymentSheet();

      // 5. Vérifier l'état de la commande via polling
      final paymentSuccess = await _pollOrderStatus(orderId);

      setState(() {
        _isLoading = false; // Cacher l'indicateur de chargement
      });

      if (paymentSuccess) {
        // Paiement réussi
        await CartManager().clearCart();
        setState(() {
          _cartItems = [];
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paiement réussi pour la commande $orderId !'),
            backgroundColor: Colors.green,
          ),
        );

        // Naviguer vers l'écran Commandes
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Commandes()),
        );
      } else {
        // Paiement échoué
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Le paiement pour la commande $orderId a échoué.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du paiement : $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Arrêter le polling si actif
      _pollingTimer?.cancel();
    }
  }

  // Mettre à jour la quantité dans CartManager
  Future<void> _updateQuantity(int index, int newQuantity) async {
    setState(() {
      _cartItems[index]["quantity"] = newQuantity;
    });
    await CartManager().updateCartItem(index, _cartItems[index]);
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_cartItems.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Votre panier est vide.')),
      );
    }

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

                // Section des produits avec fond gris
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Liste des produits
                      ..._cartItems.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> item = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: item['image'].startsWith('http')
                                          ? NetworkImage(item['image'])
                                          : AssetImage(item['image']) as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nom + bouton supprimer
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            _removeItem(index);
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _calculateItemTotalPrice(item),
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
                                                if (item["quantity"] > 1) {
                                                  _updateQuantity(
                                                    index,
                                                    item["quantity"] - 1,
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(
                                              item["quantity"].toString().padLeft(2, '0'),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.grayColor,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _updateQuantity(
                                                  index,
                                                  item["quantity"] + 1,
                                                );
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
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Section Résumé des coûts avec fond gris
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
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
                      Divider(
                        color: Colors.grey.withOpacity(0.1),
                        thickness: 1,
                      ),
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
                      Divider(
                        color: Colors.grey.withOpacity(0.1),
                        thickness: 1,
                      ),
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
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Bouton paiement
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _createOrder();
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
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 0,
                        ),
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