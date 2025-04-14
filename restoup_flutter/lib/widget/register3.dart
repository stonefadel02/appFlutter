import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/widget/register4.dart';

class Register3 extends StatefulWidget {
  const Register3({super.key});

  @override
  State<Register3> createState() => _Register3State();
}

class _Register3State extends State<Register3> {
  String? _selectedProfile = 'Restauration Commerciale'; // Profil sélectionné par défaut

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset('assets/images/logoResto 1.png'),
                const SizedBox(height: 40),

                // Texte principal
                Text(
                  'Quel est votre profil?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Afin de vous proposer un contenu adapté,',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue.withOpacity(0.5),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'veuillez sélectionner votre profil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue.withOpacity(0.5),
                  ),
                ),

                const SizedBox(height: 40),

                // Liste des options de profil avec RadioListTile
                Column(
                  children: [
                    _buildProfileOption(
                      title: 'Restauration Commerciale',
                      value: 'Restauration Commerciale',
                    ),
                    const SizedBox(height: 16),
                    _buildProfileOption(
                      title: 'Boulangerie - Pâtisserie',
                      value: 'Boulangerie - Pâtisserie',
                    ),
                    const SizedBox(height: 16),
                    _buildProfileOption(
                      title: 'Restauration Collective',
                      value: 'Restauration Collective',
                    ),
                    const SizedBox(height: 16),
                    _buildProfileOption(
                      title: 'Autres Professionnels',
                      value: 'Autres Professionnels',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Bouton "Continuer"
                ElevatedButton(
                  onPressed: () {
                        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register4()),);
                    print('Profil sélectionné : $_selectedProfile');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 6,
                    shadowColor: AppColors.primaryRed.withOpacity(0.3),
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
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

  // Widget pour construire chaque option de profil
  Widget _buildProfileOption({required String title, required String value}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.grayColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        value: value,
        groupValue: _selectedProfile,
        onChanged: (String? newValue) {
          setState(() {
            _selectedProfile = newValue;
          });
        },
        activeColor: AppColors.primaryRed, // Couleur du cercle lorsqu'il est sélectionné
        controlAffinity: ListTileControlAffinity.trailing, // Déplace le bouton radio à droite
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
    );
  }
}