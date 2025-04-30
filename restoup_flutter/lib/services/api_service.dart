import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://192.168.197.78:3000';
  String? _token;
  bool _isInitialized = false;

  ApiService() {
    // L'initialisation sera gérée via ensureInitialized
  }

  // Charger le token depuis SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    print('Token chargé: $_token');
  }

  // Méthode pour s'assurer que l'initialisation est terminée
  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await _loadToken();
      _isInitialized = true;
    }
  }

  // Sauvegarder le token dans SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _token = token;
    print('Token sauvegardé: $_token');
  }

  // Méthode pour vérifier si l'utilisateur est connecté
  bool isAuthenticated() {
    return _token != null;
  }

  // Supprimer le token (pour la déconnexion par exemple)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
    _isInitialized = false; // Réinitialiser l'état
    print('Token supprimé');
  }

  Future<Map<String, String>> _getHeaders() async {
    await ensureInitialized();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_token ?? ''}',
    };
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String companyName,
    required String contactName,
    required String contactFirstName,
    required String siret,
    required String postalAddress,
    File? identityDocumentFile,
    required String deliveryAddress,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/partner/auth/register');
    final request = http.MultipartRequest('POST', uri);

    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['companyName'] = companyName;
    request.fields['contactName'] = contactName;
    request.fields['contactFirstName'] = contactFirstName;
    request.fields['siret'] = siret;
    request.fields['postalAddress'] = postalAddress;
    request.fields['deliveryAddress'] = deliveryAddress;

    if (identityDocumentFile != null) {
      final fileStream = http.ByteStream(identityDocumentFile.openRead());
      final fileLength = await identityDocumentFile.length();
      final multipartFile = http.MultipartFile(
        'photo',
        fileStream,
        fileLength,
        filename: identityDocumentFile.path.split('/').last,
      );
      request.files.add(multipartFile);
      print('Fichier inclus dans la requête :');
      print('Nom du champ: photo');
      print('Nom du fichier: ${identityDocumentFile.path.split('/').last}');
      print('Taille du fichier: $fileLength octets');
    } else {
      print('Aucun fichier inclus dans la requête.');
    }

    print('Envoi de la requête d\'inscription à $uri...');
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('Code de statut: ${response.statusCode}');
    print('Réponse: $responseBody');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(responseBody);
    } else {
      throw Exception('Erreur lors de l\'inscription: ${response.statusCode} - $responseBody');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/api/v1/partner/auth/login-restaurant');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    print('Envoi de la requête de login à $uri...');
    print('Body: $body');

    final response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    print('Code de statut: ${response.statusCode}');
    print('Réponse: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // Vérifier si le token existe avant de l'utiliser
      if (responseData['data'] != null && responseData['data']['token'] != null) {
        await _saveToken(responseData['data']['token']);
        return responseData;
      } else {
        throw Exception('Token non trouvé dans la réponse');
      }
    } else {
      throw Exception('Erreur lors de la connexion: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getProductVariants({
    int page = 1,
    int limit = 20,
  }) async {
    await ensureInitialized();

    if (_token == null) {
      throw Exception('Utilisateur non authentifié. Veuillez vous connecter.');
    }

    final uri = Uri.parse('$baseUrl/api/v1/partner/product-variants?page=$page&limit=$limit');
    final headers = await _getHeaders();

    print('Envoi de la requête GET à $uri...');
    print('Headers: $headers');

    final response = await http.get(
      uri,
      headers: headers,
    );

    print('Code de statut: ${response.statusCode}');
    print('Réponse: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await clearToken();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else {
      throw Exception('Erreur lors de la récupération des produits: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getProductVariantById(String productVariantId) async {
    await ensureInitialized();

    if (_token == null) {
      throw Exception('Utilisateur non authentifié. Veuillez vous connecter.');
    }

    final uri = Uri.parse('$baseUrl/api/v1/partner/product-variants/$productVariantId');
    final headers = await _getHeaders();

    print('Envoi de la requête GET à $uri...');

    final response = await http.get(
      uri,
      headers: headers,
    );

    print('Code de statut: ${response.statusCode}');
    print('Réponse: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await clearToken();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else {
      throw Exception('Erreur lors de la récupération de la variante: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createOrder(List<Map<String, dynamic>> items) async {
    await ensureInitialized();

    if (_token == null) {
      throw Exception('Utilisateur non authentifié. Veuillez vous connecter.');
    }

    final uri = Uri.parse('$baseUrl/api/v1/partner/orders');
    final headers = await _getHeaders();

    final body = jsonEncode({
      'items': items,
    });

    print('Envoi de la requête de création de commande à $uri...');
    print('Body: $body');

    final response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    print('Code de statut: ${response.statusCode}');
    print('Réponse: ${response.body}');

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await clearToken();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else {
      throw Exception('Erreur lors de la création de la commande: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
    String? dateFrom,
    String? dateTo,
  }) async {
    await ensureInitialized();

    if (_token == null) {
      throw Exception('Utilisateur non authentifié. Veuillez vous connecter.');
    }

    final queryParameters = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      if (status != null) 'status': status,
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    };
    final uri = Uri.parse('$baseUrl/api/v1/partner/orders').replace(queryParameters: queryParameters);
    final headers = await _getHeaders();

    print('Envoi de la requête GET à $uri...');

    final response = await http.get(
      uri,
      headers: headers,
    );

    print('Code de statut: ${response.statusCode}');
    print('Réponse: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await clearToken();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else {
      throw Exception('Erreur lors de la récupération des commandes: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    await ensureInitialized();

    if (_token == null) {
      throw Exception('Utilisateur non authentifié. Veuillez vous connecter.');
    }

    final uri = Uri.parse('$baseUrl/api/v1/partner/orders/$orderId');
    final headers = await _getHeaders();

    print('Envoi de la requête GET à $uri...');

    final response = await http.get(
      uri,
      headers: headers,
    );

    print('Code de statut: ${response.statusCode}');
    print('Réponse: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await clearToken();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else {
      throw Exception('Erreur lors de la récupération des détails de la commande: ${response.statusCode} - ${response.body}');
    }
  }

    // Récupérer la liste des favoris
  Future<Map<String, dynamic>> getFavorites({
    int page = 1,
    int limit = 20,
  }) async {
    await ensureInitialized();

    if (_token == null) {
      throw Exception('Utilisateur non authentifié. Veuillez vous connecter.');
    }

    final uri = Uri.parse('$baseUrl/api/v1/partner/product-variants/favorites?page=$page&limit=$limit');
    final headers = await _getHeaders();

    print('Envoi de la requête GET à $uri...');

    final response = await http.get(
      uri,
      headers: headers,
    );

    print('Code de statut: ${response.statusCode}');
    print('Réponse: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await clearToken();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else {
      throw Exception('Erreur lors de la récupération des favoris: ${response.statusCode} - ${response.body}');
    }
  }

  // Ajouter un produit aux favoris
  Future<Map<String, dynamic>> addToFavorites(String productVariantId) async {
    await ensureInitialized();

    if (_token == null) {
      throw Exception('Utilisateur non authentifié. Veuillez vous connecter.');
    }

    final uri = Uri.parse('$baseUrl/api/v1/partner/product-variants/$productVariantId/favorite');
    final headers = await _getHeaders();

    print('Envoi de la requête POST à $uri...');

    final response = await http.post(
      uri,
      headers: headers,
    );

    print('Code de statut: ${response.statusCode}');
    print('Réponse: ${response.body}');

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await clearToken();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else {
      throw Exception('Erreur lors de l\'ajout aux favoris: ${response.statusCode} - ${response.body}');
    }
  }


  // Récupérer les informations du profil
  Future<Map<String, dynamic>> getProfile() async {
    await ensureInitialized();

    if (_token == null) {
      throw Exception('Utilisateur non authentifié. Veuillez vous connecter.');
    }

    final uri = Uri.parse('$baseUrl/api/v1/partner/restaurants/me');
    final headers = await _getHeaders();

    print('Envoi de la requête GET à $uri...');

    final response = await http.get(
      uri,
      headers: headers,
    );

    print('Code de statut: ${response.statusCode}');
    print('Réponse: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await clearToken();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else {
      throw Exception('Erreur lors de la récupération du profil: ${response.statusCode} - ${response.body}');
    }
  }


  // Supprimer un produit des favoris
   // Supprimer un produit des favoris
  Future<Map<String, dynamic>> removeFromFavorites(String productVariantId) async {
    await ensureInitialized();

    if (_token == null) {
      throw Exception('Utilisateur non authentifié. Veuillez vous connecter.');
    }

    final uri = Uri.parse('$baseUrl/api/v1/partner/product-variants/$productVariantId/favorite');
    final headers = await _getHeaders();

    print('Envoi de la requête DELETE à $uri...');

    final response = await http.delete(
      uri,
      headers: headers,
    );

    print('Code de statut: ${response.statusCode}');
    print('Réponse: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204 || response.statusCode == 404) {
      // 200 ou 204 : Suppression réussie
      // 404 : Le produit n'était pas dans les favoris, mais l'objectif est atteint (il n'est plus dans les favoris)
      return response.statusCode == 404
          ? {'data': {'message': 'Produit déjà retiré des favoris'}, 'error': null}
          : response.body.isNotEmpty
              ? jsonDecode(response.body)
              : {'data': {'message': 'Produit supprimé des favoris avec succès'}, 'error': null};
    } else if (response.statusCode == 401) {
      await clearToken();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else {
      throw Exception('Erreur lors de la suppression des favoris: ${response.statusCode} - ${response.body}');
    }
  }

    // Mettre à jour le profil
  Future<Map<String, dynamic>> updateProfile({
    String? companyName,
    String? contactName,
    String? contactFirstName,
    String? password,
    String? postalAddress,
    String? deliveryAddress,
    File? logoFile,
  }) async {
    await ensureInitialized();

    if (_token == null) {
      throw Exception('Utilisateur non authentifié. Veuillez vous connecter.');
    }

    final uri = Uri.parse('$baseUrl/api/v1/partner/restaurants/me');
    final request = http.MultipartRequest('PATCH', uri);

    // Ajouter les champs texte (seulement s'ils sont fournis)
    if (companyName != null) request.fields['companyName'] = companyName;
    if (contactName != null) request.fields['contactName'] = contactName;
    if (contactFirstName != null) request.fields['contactFirstName'] = contactFirstName;
    if (password != null) request.fields['password'] = password;
    if (postalAddress != null) request.fields['postalAddress'] = postalAddress;
    if (deliveryAddress != null) request.fields['deliveryAddress'] = deliveryAddress;

    // Ajouter le fichier logo (si fourni)
    if (logoFile != null) {
      final fileStream = http.ByteStream(logoFile.openRead());
      final fileLength = await logoFile.length();
      final multipartFile = http.MultipartFile(
        'logo',
        fileStream,
        fileLength,
        filename: logoFile.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    // Ajouter les en-têtes
    request.headers.addAll(await _getHeaders());

    print('Envoi de la requête PATCH à $uri...');
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('Code de statut: ${response.statusCode}');
    print('Réponse: $responseBody');

    if (response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else if (response.statusCode == 401) {
      await clearToken();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else {
      throw Exception('Erreur lors de la mise à jour du profil: ${response.statusCode} - $responseBody');
    }
  }

  // Nouvelle méthode pour créer un PaymentIntent
  Future<Map<String, dynamic>> createPaymentIntent(String orderId, double amount) async {
    await ensureInitialized();

    if (_token == null) {
      throw Exception('Utilisateur non authentifié. Veuillez vous connecter.');
    }

    final uri = Uri.parse('$baseUrl/api/v1/partner/payments');
    final headers = await _getHeaders();

    final body = jsonEncode({
      'orderId': orderId,
      'amount': (amount * 100).toInt(), // Stripe attend le montant en centimes
      'currency': 'eur',
    });

    print('Envoi de la requête de création de PaymentIntent à $uri...');
    print('Body: $body');

    final response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    print('Code de statut: ${response.statusCode}');
    print('Réponse: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await clearToken();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else {
      throw Exception('Erreur lors de la création du PaymentIntent: ${response.statusCode} - ${response.body}');
    }
  }
}