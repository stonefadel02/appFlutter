import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  static const String baseUrl = 'http://192.168.179.78:3000';

  // Créer une commande
  Future<Map<String, dynamic>> createOrder(List<Map<String, dynamic>> items) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        // Pour les tests, ajouter l'ID du restaurant dans le header (non sécurisé, à remplacer par une vraie authentification)
        'X-Restaurant-ID': 'test-restaurant-id', // Remplacer par un vrai ID de restaurant
      },
      body: jsonEncode({
        'items': items,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Erreur lors de la création de la commande: ${response.body}');
    }
  }

  // Lister les commandes
  Future<List<Map<String, dynamic>>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (status != null) 'status': status,
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {
        'X-Restaurant-ID': 'test-restaurant-id', // Remplacer par un vrai ID de restaurant
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Erreur lors de la récupération des commandes: ${response.body}');
    }
  }

  // Récupérer les détails d'une commande
  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$orderId'),
      headers: {
        'X-Restaurant-ID': 'test-restaurant-id', // Remplacer par un vrai ID de restaurant
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Erreur lors de la récupération des détails de la commande: ${response.body}');
    }
  }
}