import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/widget/register4.dart';

class Register3 extends StatefulWidget {
  final String email;
  final String password;
  final String contactName;
  final String contactFirstName;
  final String siret;
  final String companyName;
  final String postalAddress;
  final String? identityDocumentUrl;

  const Register3({
    super.key,
    required this.email,
    required this.password,
    required this.contactName,
    required this.contactFirstName,
    required this.siret,
    required this.companyName,
    required this.postalAddress,
    this.identityDocumentUrl,
  });

  @override
  State<Register3> createState() => _Register3State();
}

class _Register3State extends State<Register3> {
  String? _selectedProfile = 'Restauration Commerciale';

  void _proceedToNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Register4(
          email: widget.email,
          password: widget.password,
          contactName: widget.contactName,
          contactFirstName: widget.contactFirstName,
          siret: widget.siret,
          companyName: widget.companyName,
          postalAddress: widget.postalAddress,
          identityDocumentUrl: widget.identityDocumentUrl,
        ),
      ),
    );
  }

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
                Image.asset('assets/images/logoResto 1.png'),
                const SizedBox(height: 40),
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
                    color: AppColors.grayColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'veuillez sélectionner votre profil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grayColor,
                  ),
                ),
                const SizedBox(height: 40),
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
                ElevatedButton(
                  onPressed: _proceedToNext,
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

  Widget _buildProfileOption({required String title, required String value}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grayColor.withOpacity(0.1),
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
        activeColor: AppColors.primaryRed,
        controlAffinity: ListTileControlAffinity.trailing,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
    );
  }
}