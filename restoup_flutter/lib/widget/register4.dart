import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/services/api_service.dart';
import 'package:restoup_flutter/widget/registerSuccess.dart';

class Register4 extends StatefulWidget {
  final String email;
  final String password;
  final String contactName;
  final String contactFirstName;
  final String siret;
  final String companyName;
  final String postalAddress;
  final File? selectedFile; // Recevoir le fichier

  const Register4({
    super.key,
    required this.email,
    required this.password,
    required this.contactName,
    required this.contactFirstName,
    required this.siret,
    required this.companyName,
    required this.postalAddress,
    this.selectedFile,
  });

  @override
  State<Register4> createState() => _Register4State();
}

class _Register4State extends State<Register4> {
  final TextEditingController _addressController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _submitForm() async {
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
      // Afficher les données qui seront envoyées au backend
      print('Données envoyées au backend :');
      print('Email: ${widget.email}');
      print('Password: ${widget.password}');
      print('Company Name: ${widget.companyName}');
      print('Contact Name: ${widget.contactName}');
      print('Contact First Name: ${widget.contactFirstName}');
      print('SIRET: ${widget.siret}');
      print('Postal Address: ${widget.postalAddress}');
      print('Delivery Address: ${_addressController.text.trim()}');
      print('Fichier sélectionné: ${widget.selectedFile != null ? widget.selectedFile!.path : "Aucun fichier"}');

      final response = await _apiService.register(
        email: widget.email,
        password: widget.password,
        companyName: widget.companyName,
        contactName: widget.contactName,
        contactFirstName: widget.contactFirstName,
        siret: widget.siret,
        postalAddress: widget.postalAddress,
        identityDocumentFile: widget.selectedFile, // Envoyer le fichier
        deliveryAddress: _addressController.text.trim(),
      );

      if (response['error'] == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegisterSuccess()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${response['error']}')),
        );
      }
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'inscription: $e')),
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
                  'Adresse de livraison',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Entrez votre adresse de livraison',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 40),
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
                            Icons.check_circle,
                            color: AppColors.grayColor,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
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
                              'Terminer',
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