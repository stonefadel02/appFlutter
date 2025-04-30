import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/services/api_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactFirstNameController = TextEditingController();
  final TextEditingController _postalAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedFileName;
  File? _selectedFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
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
        _companyNameController.text = _profileData?['companyName'] ?? '';
        _contactNameController.text = _profileData?['contactName'] ?? '';
        _contactFirstNameController.text = _profileData?['contactFirstName'] ?? '';
        _postalAddressController.text = _profileData?['postalAddress'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement du profil: $e')),
      );
    }
  }

  Future<void> _pickFile() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() {
          _selectedFileName = file.path.split('/').last;
          _selectedFile = file;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucun fichier sélectionné')),
        );
      }
    } catch (e) {
      print('Erreur lors de la sélection du fichier: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (_companyNameController.text.isEmpty ||
        _contactNameController.text.isEmpty ||
        _contactFirstNameController.text.isEmpty ||
        _postalAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.updateProfile(
        companyName: _companyNameController.text.trim(),
        contactName: _contactNameController.text.trim(),
        contactFirstName: _contactFirstNameController.text.trim(),
        postalAddress: _postalAddressController.text.trim(),
        password: _passwordController.text.isNotEmpty ? _passwordController.text.trim() : null,
        logoFile: _selectedFile,
      );

      if (response['error'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${response['error']}')),
        );
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du profil: $e');
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
    _companyNameController.dispose();
    _contactNameController.dispose();
    _contactFirstNameController.dispose();
    _postalAddressController.dispose();
    _passwordController.dispose();
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
                      "Votre Profil",
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
                  "Mettez à jour vos informations",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // Champ pour la raison sociale
                TextField(
                  controller: _companyNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Raison Sociale",
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
                    suffixIcon: _companyNameController.text.isNotEmpty
                        ? Icon(
                            Icons.check_circle,
                            color: AppColors.grayColor,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Champ pour le nom du contact
                TextField(
                  controller: _contactNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Nom du Contact",
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
                    suffixIcon: _contactNameController.text.isNotEmpty
                        ? Icon(
                            Icons.check_circle,
                            color: AppColors.grayColor,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Champ pour le prénom du contact
                TextField(
                  controller: _contactFirstNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Prénom du Contact",
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
                    suffixIcon: _contactFirstNameController.text.isNotEmpty
                        ? Icon(
                            Icons.check_circle,
                            color: AppColors.grayColor,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Champ pour l'adresse postale
                TextField(
                  controller: _postalAddressController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Adresse Postale",
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
                    suffixIcon: _postalAddressController.text.isNotEmpty
                        ? Icon(
                            Icons.check_circle,
                            color: AppColors.grayColor,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Champ pour le mot de passe
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Nouveau Mot de Passe (optionnel)",
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
                    suffixIcon: _passwordController.text.isNotEmpty
                        ? Icon(
                            Icons.check_circle,
                            color: AppColors.grayColor,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Champ pour le fichier
                InkWell(
                  onTap: _pickFile,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.grayColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grayColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.attach_file, color: AppColors.darkBlue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedFileName ?? "Aucun fichier sélectionné",
                            style: TextStyle(color: AppColors.grayColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Bouton "Sauvegarder"
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}