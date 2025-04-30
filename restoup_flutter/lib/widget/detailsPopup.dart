import 'package:flutter/material.dart';
import 'package:restoup_flutter/services/api_service.dart';

class OrderDetailsPopup extends StatefulWidget {
  final String orderId;

  const OrderDetailsPopup({super.key, required this.orderId});

  @override
  State<OrderDetailsPopup> createState() => _OrderDetailsPopupState();
}

class _OrderDetailsPopupState extends State<OrderDetailsPopup> {
  List<Map<String, dynamic>> products = [];
  bool _isLoading = true;
  String? _error;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    try {
      final response = await apiService.getOrderDetails(widget.orderId);
      setState(() {
        products = List<Map<String, dynamic>>.from(response['data']['orderItems'] ?? []);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        // Limiter la longueur de l'erreur pour éviter un débordement
        String errorMessage = e.toString();
        if (errorMessage.length > 200) {
          errorMessage = errorMessage.substring(0, 200) + '...';
        }
        _error = errorMessage;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8, // Limiter la hauteur du Dialog
        ),
        child: _isLoading
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Chargement des détails..."),
                  ],
                ),
              )
            : _error != null
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Erreur : $_error"),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Fermer"),
                          ),
                        ],
                      ),
                    ),
                  )
                : products.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Aucun produit trouvé dans cette commande."),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Fermer"),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
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
                                    "Détails Produit",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Liste des produits
                              for (var product in products) ...[
                                Row(
                                  children: [
                                    // Image du produit (ronde)
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle, // Rendre le conteneur circulaire
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(35), // Rayon pour un cercle parfait (moitié de width/height)
                                        child: product['productVariant']?['imageUrl'] != null
                                            ? Image.network(
                                                product['productVariant']['imageUrl'],
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/product.png',
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              )
                                            : Image.asset(
                                                'assets/images/product.png',
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Nom du produit en deux parties
                                          Row(
                                            children: [
                                              Text(
                                                // Première partie du nom (avant le premier espace)
                                                (product['productVariant']?['product']?['name'] ?? 'Produit inconnu')
                                                    .split(' ')
                                                    .first,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                // Deuxième partie du nom (après le premier espace)
                                                (product['productVariant']?['product']?['name'] ?? '')
                                                        .split(' ')
                                                        .length >
                                                    1
                                                    ? (product['productVariant']['product']['name'] as String)
                                                        .split(' ')
                                                        .sublist(1)
                                                        .join(' ')
                                                    : '',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          // Marque statique "Maggi"
                                          const Text(
                                            "Maggi",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              // Quantité
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  product['quantity']?.toString() ?? '0',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Prix et unité
                                              Text(
                                                "€${product['priceAtOrderTime']?.toStringAsFixed(2) ?? '0.00'} ${product['productVariant']?['product']?['unit'] ?? 'N/A'}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}