import 'package:flutter/material.dart';
import 'package:restoup_flutter/accueil/favoris.dart';
import 'package:restoup_flutter/accueil/homeScreen.dart';
import 'package:restoup_flutter/accueil/notificationScreen.dart';
import 'package:restoup_flutter/accueil/trackingScreen.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/widget/cancelPopup.dart';
import 'package:restoup_flutter/widget/detailsPopup.dart';
import 'package:restoup_flutter/services/api_service.dart';
import 'package:restoup_flutter/widget/cartScreen.dart';
import 'package:restoup_flutter/widget/cart_manager.dart';

class Commandes extends StatefulWidget {
  const Commandes({super.key});

  @override
  State<Commandes> createState() => _CommandesState();
}

class _CommandesState extends State<Commandes> {
  List<Map<String, dynamic>> orders = [];
  List<bool> isDetailPressedList = [];
  bool _isLoading = true;
  String? _error;
  int _cartItemCount = 0;

  final ApiService apiService = ApiService();
  final CartManager _cartManager = CartManager();

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _loadCartItemCount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadOrders(); // Recharger les commandes chaque fois que l'écran devient visible
    _loadCartItemCount();
  }

  Future<void> _loadOrders() async {
    try {
      final response = await apiService.getOrders(
        page: 1,
        limit: 20,
      );
      setState(() {
        orders = List<Map<String, dynamic>>.from(response['data']['orders'] ?? []);
        isDetailPressedList = List<bool>.filled(orders.length, false);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCartItemCount() async {
    try {
      final count = await _cartManager.getCartItemCount();
      setState(() {
        _cartItemCount = count;
      });
    } catch (e) {
      print('Erreur lors du chargement du nombre d\'articles dans le panier: $e');
    }
  }

  void _cancelOrder(int index, String reason) {
    setState(() {
      orders.removeAt(index);
      isDetailPressedList.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Commande annulée avec succès. Raison : $reason"),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String _formatTime(String dateTime) {
    final date = DateTime.parse(dateTime);
    return "à ${date.hour.toString().padLeft(2, '0')}H${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('Erreur : $_error')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Mes Commandes",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 28,
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                  size: 28,
                ),
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: orders.isEmpty
          ? const Center(child: Text('Aucune commande trouvée.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  color: Colors.white,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Montant de la commande",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.grayColor,
                              ),
                            ),
                            Text(
                              _formatDate(order['createdAt']),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "€${order['totalPrice'].toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              _formatTime(order['createdAt']),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Temps d’arrivée",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.grayColor,
                              ),
                            ),
                            GestureDetector(
                              onTapDown: (_) {
                                setState(() {
                                  isDetailPressedList[index] = true;
                                });
                              },
                              onTapUp: (_) {
                                setState(() {
                                  isDetailPressedList[index] = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (context) => OrderDetailsPopup(
                                    orderId: order['id'],
                                  ),
                                );
                              },
                              onTapCancel: () {
                                setState(() {
                                  isDetailPressedList[index] = false;
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order['estimatedDeliveryTime']?.toString() ?? '25 min',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "${order['orderItemsCount'] ?? 0} Produit${(order['orderItemsCount'] ?? 0) > 1 ? 's' : ''} commandé${(order['orderItemsCount'] ?? 0) > 1 ? 's' : ''}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CancelReasonPopup(
                                      onSubmit: (reason) {
                                        _cancelOrder(index, reason);
                                      },
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[50],
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
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
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Favoris()),
            );
          }
        },
      ),
    );
  }
}