import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StripeService {
  final String baseUrl = 'http://192.168.179.78:3000';
  String? _token;

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    await _loadToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_token ?? ''}',
    };
  }

  Future<Map<String, dynamic>> createPaymentIntent(String orderId, double amount) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('$baseUrl/api/v1/partner/payments/create-intent');
      
      // Convertir le montant en centimes comme l'exige Stripe
      final amountInCents = (amount * 100).toInt();
      
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'amount': amountInCents,
          'currency': 'eur',
          'orderId': orderId,
        }),
      );

      print('Réponse de createPaymentIntent: ${response.body}');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur lors de la création du PaymentIntent: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la création du PaymentIntent: $e');
    }
  }

  Future<void> initPaymentSheet({
    required String paymentIntentClientSecret,
    required String merchantDisplayName,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: merchantDisplayName,
          style: ThemeMode.light,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Colors.red,
            ),
          ),
        ),
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'initialisation du PaymentSheet: $e');
    }
  }

  Future<bool> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (e) {
      print('Erreur lors de la présentation du PaymentSheet: $e');
      return false;
    }
  }

  Future<bool> processPayment(String orderId, double amount, String merchantName) async {
    try {
      // 1. Créer un PaymentIntent sur le serveur
      final paymentIntentResult = await createPaymentIntent(orderId, amount);
      final clientSecret = paymentIntentResult['data']['clientSecret'];
      
      if (clientSecret == null) {
        throw Exception('Client secret non trouvé dans la réponse');
      }

      // 2. Configurer la feuille de paiement
      await initPaymentSheet(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: merchantName,
      );

      // 3. Afficher la feuille de paiement et attendre la confirmation
      final success = await presentPaymentSheet();
      return success;
    } catch (e) {
      print('Erreur dans processPayment: $e');
      return false;
    }
  }
}