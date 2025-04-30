import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartManager {
  static const String _cartKey = 'cart_items';

  // Ajouter un produit au panier
  Future<void> addToCart({
    required String name,
    required String price,
    required String image,
    required int quantity,
    required String brand,
    required String productVariantId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(_cartKey) ?? [];

    final item = {
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
      'brand': brand,
      'productVariantId': productVariantId,
    };

    cartItems.add(jsonEncode(item));
    await prefs.setStringList(_cartKey, cartItems);
  }

  // Récupérer les éléments du panier
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(_cartKey) ?? [];
    return cartItems.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
  }

  // Supprimer un élément du panier
  Future<void> removeFromCart(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(_cartKey) ?? [];
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      await prefs.setStringList(_cartKey, cartItems);
    }
  }

  // Mettre à jour un élément du panier
  Future<void> updateCartItem(int index, Map<String, dynamic> updatedItem) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(_cartKey) ?? [];
    if (index >= 0 && index < cartItems.length) {
      cartItems[index] = jsonEncode(updatedItem);
      await prefs.setStringList(_cartKey, cartItems);
    }
  }
  Future<int> getCartItemCount() async {
    final cartItems = await getCartItems(); // Assuming getCartItems returns the list of cart items
    return cartItems.length;
  }

  // Vider le panier
  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

  // Vérifier si un produit est dans le panier
  Future<bool> isInCart(String productVariantId) async {
    final cartItems = await getCartItems();
    return cartItems.any((item) => item['productVariantId'] == productVariantId);
  }
}