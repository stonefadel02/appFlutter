import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl = 'http://10.0.2.2:3000'; // Pour émulateur Android (NDK 25)
   static const String baseUrl = 'http://localhost:3000'; // Pour iOS ou web

  // Méthode pour l'inscription
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String companyName,
    required String contactName,
    required String contactFirstName,
    required String deliveryAddress,
    required String siret,
    
    required String postalAddress,
    String? identityDocumentUrl,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/partner/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'companyName': companyName,
        'contactName': contactName,
        'contactFirstName': contactFirstName,
        'deliveryAddress': deliveryAddress,
        'siret': siret,
        'postalAddress': postalAddress,
        'identityDocumentUrl': identityDocumentUrl,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors de l\'inscription: ${response.statusCode} - ${response.body}');
    }
  }

  
}