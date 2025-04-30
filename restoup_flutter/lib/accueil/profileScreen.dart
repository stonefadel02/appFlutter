import 'package:flutter/material.dart';
import 'package:restoup_flutter/accueil/PrivacyPolicyScreen.dart';
import 'package:restoup_flutter/accueil/editProfile.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/widget/NotificationSettingsScreen.dart';
import 'package:restoup_flutter/services/api_service.dart';
import 'package:restoup_flutter/widget/editAdress.dart';
import 'package:restoup_flutter/widget/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthentication();
    });
  }

  Future<void> _checkAuthentication() async {
    if (!mounted) return;
    await _apiService.ensureInitialized();
    if (!_apiService.isAuthenticated()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
    }
    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final response = await _apiService.getProfile();
      if (!mounted) return;
      setState(() {
        _profileData = response['data'];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _apiService.clearToken();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la déconnexion: $e')),
      );
    }
  }

  void _showLogoutBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white, // Fond blanc explicite pour le Bottom Sheet
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: 250, // Hauteur fixe pour un Bottom Sheet plus grand
        child: Container(
          color: Colors.white, // Fond blanc explicite pour le Container
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centrer verticalement le contenu
            children: [
              // Titre avec icône
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.logout,
                    color: AppColors.primaryRed,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Déconnexion",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24), // Augmenté l'espacement pour plus d'aération

              // Message
              const Text(
                "Voulez-vous vraiment vous déconnecter ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grayColor,
                ),
              ),
              const SizedBox(height: 32), // Augmenté l'espacement pour plus d'aération

              // Boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Bouton "Annuler"
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: const Text(
                        "Annuler",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Bouton "Se déconnecter"
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Se déconnecter",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white, // Fond blanc pour l'écran de chargement
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.white, // Fond blanc pour l'écran d'erreur
        body: Center(child: Text('Erreur : $_error')),
      );
    }

    final name = '${_profileData?['contactFirstName'] ?? ''} ${_profileData?['contactName'] ?? ''}'.trim();
    final email = _profileData?['email'] ?? 'Email non disponible';
    final logoUrl = _profileData?['logoUrl']?.toString();

    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc pour toute la page
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // En-tête avec fond jaune
              Container(
                color: const Color(0xFFFFD700), // Jaune
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    // Flèche de retour avec fond blanc
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Retour à la page précédente
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Image de profil
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: logoUrl != null && logoUrl.isNotEmpty
                              ? NetworkImage(logoUrl)
                              : const AssetImage("assets/images/profile.png") as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Nom de l'utilisateur (centré, blanc)
                    Text(
                      name.isNotEmpty ? name : 'Nom non disponible',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // Adresse e-mail (centré, blanc)
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Liste des options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOption(
                      icon: Icons.person,
                      title: "Votre Profil",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                        ).then((_) => _loadProfile()); // Recharger le profil après modification
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildOption(
                      icon: Icons.location_on,
                      title: "Adresse de livraison",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditAddressScreen()),
                        ).then((_) => _loadProfile()); // Recharger le profil après modification
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildOption(
                      icon: Icons.notifications,
                      title: "Notification",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildOption(
                      icon: Icons.lock,
                      title: "Sécurité",
                      onTap: () {
                        // Naviguer vers la page de sécurité
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildOption(
                      icon: Icons.privacy_tip,
                      title: "Politique et Confidentialité",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 60),

                    // Bouton "Déconnexion" avec Bottom Sheet
                    SizedBox(
                      width: 200,
                      child: ElevatedButton.icon(
                        onPressed: _showLogoutBottomSheet, // Appeler la méthode du Bottom Sheet
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          "Déconnexion",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }
}