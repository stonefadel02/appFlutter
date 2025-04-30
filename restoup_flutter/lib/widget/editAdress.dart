import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/services/api_service.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({super.key});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _apiService.getProfile();
      setState(() {
        _profileData = response['data'];
        _addressController.text = _profileData?['deliveryAddress'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement de l\'adresse: $e')),
      );
    }
  }

  Future<void> _saveAddress() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer une adresse de livraison')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.updateProfile(
        deliveryAddress: _addressController.text.trim(),
      );

      if (response['error'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adresse mise à jour avec succès')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${response['error']}')),
        );
      }
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'adresse: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white, // Fond blanc pour l'écran de chargement
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc pour toute la page
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre personnalisé avec flèche de retour
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      "Modifier l'Adresse",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 20),

                // Sous-titre
                const Text(
                  "Mettez à jour votre adresse de livraison",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // Champ pour l'adresse de livraison
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Adresse de livraison",
                    labelStyle: TextStyle(color: AppColors.grayColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.grayColor.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.grayColor.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: _addressController.text.isNotEmpty
                        ? Icon(
                            Icons.location_on, // Remplacé par une icône de localisation
                            color: AppColors.grayColor,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 40),

                // Bouton "Sauvegarder" (pleine largeur)
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 6,
                    shadowColor: AppColors.primaryRed.withOpacity(0.3),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sauvegarder',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}