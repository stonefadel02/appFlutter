import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/widget/register3.dart';
import 'package:image_picker/image_picker.dart';

class Register2 extends StatefulWidget {
  final String email;
  final String password;

  const Register2({super.key, required this.email, required this.password});

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  String? _selectedFileName;
  File? _selectedFile; // Stocker le fichier sélectionné
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactFirstNameController = TextEditingController();
  final TextEditingController _siretController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _postalAddressController = TextEditingController();
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile() async {
    try {
      // Sélectionner un fichier depuis la galerie
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() {
          _selectedFileName = file.path.split('/').last;
          _selectedFile = file; // Stocker le fichier
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

  void _validateAndProceed() {
    if (_contactNameController.text.isEmpty ||
        _contactFirstNameController.text.isEmpty ||
        _siretController.text.isEmpty ||
        _companyNameController.text.isEmpty ||
        _postalAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Register3(
          email: widget.email,
          password: widget.password,
          contactName: _contactNameController.text.trim(),
          contactFirstName: _contactFirstNameController.text.trim(),
          siret: _siretController.text.trim(),
          companyName: _companyNameController.text.trim(),
          postalAddress: _postalAddressController.text.trim(),
          selectedFile: _selectedFile, // Passer le fichier à Register3
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _contactFirstNameController.dispose();
    _siretController.dispose();
    _companyNameController.dispose();
    _postalAddressController.dispose();
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
                  'Hello! Créer un compte',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Finaliser la création de votre compte',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _contactNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Nom",
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
                TextField(
                  controller: _contactFirstNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Prénom",
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
                TextField(
                  controller: _siretController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "SIRET",
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
                    suffixIcon: _siretController.text.isNotEmpty
                        ? Icon(
                            Icons.check_circle,
                            color: AppColors.grayColor,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
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
                TextField(
                  controller: _postalAddressController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayColor.withOpacity(0.1),
                    labelText: "Adresse postale",
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
                InkWell(
                  onTap: _pickFile,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _validateAndProceed,
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
                              'Suivant',
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