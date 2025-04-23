import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:minio/io.dart';
import 'package:restoup_flutter/color/color.dart';
import 'package:restoup_flutter/widget/register3.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:minio/minio.dart';

class Register2 extends StatefulWidget {
  final String email;
  final String password;

  const Register2({super.key, required this.email, required this.password});

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  String? _selectedFileName;
  String? _identityDocumentUrl;
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactFirstNameController = TextEditingController();
  final TextEditingController _siretController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _postalAddressController = TextEditingController();
  bool _isLoading = false;

  Future<void> _pickFile() async {
    final params = OpenFileDialogParams(
      dialogType: OpenFileDialogType.document,
      sourceType: SourceType.photoLibrary,
      allowEditing: false,
    );

    final filePath = await FlutterFileDialog.pickFile(params: params);

    if (filePath != null) {
      final file = File(filePath);
      setState(() {
        _selectedFileName = file.path.split('/').last;
      });
      await _uploadFile(file);
    }
  }

  // Méthode pour uploader le fichier vers DigitalOcean Spaces


Future<void> _uploadFile(File file) async {
  setState(() {
    _isLoading = true;
  });

  try {
    // Récupération des variables d'environnement
    final accessKey = dotenv.env['AWS_ACCESS_KEY_ID'];
    final secretKey = dotenv.env['AWS_SECRET_ACCESS_KEY'];
    final endpoint = dotenv.env['S3_ENDPOINT'];
    final cdnUrl = dotenv.env['S3_CDN_URL'];
    
    if (accessKey == null || secretKey == null || endpoint == null || cdnUrl == null) {
      throw Exception('Variables d\'environnement manquantes');
    }

    final bucketName = 'ipcm-bucket'; // Remplacer par votre nom de bucket
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    final objectName = 'uploads/$fileName';

    // Lire le fichier comme bytes
    final fileBytes = await file.readAsBytes();
    final contentType = 'image/jpeg'; // Ajuster selon le type de fichier
    
    // Créer une requête PUT directe vers S3
    final uri = Uri.parse('https://$bucketName.$endpoint/$objectName');
    
    print('Envoi de la requête d\'upload à $uri');
    
    // Créer la requête
    final request = http.Request('PUT', uri);
    request.headers['Content-Type'] = contentType;
    request.headers['x-amz-acl'] = 'public-read';
    
    // Ajouter l'autorisation basique
    final authString = 'AWS $accessKey:$secretKey';
    request.headers['Authorization'] = authString;
    
    // Ajouter le corps de la requête
    request.bodyBytes = fileBytes;
    
    // Envoyer la requête
    final httpClient = http.Client();
    final streamedResponse = await httpClient.send(request);
    
    print('Code de statut: ${streamedResponse.statusCode}');
    final responseBody = await streamedResponse.stream.bytesToString();
    print('Réponse: $responseBody');
    
    if (streamedResponse.statusCode == 200) {
      setState(() {
        _identityDocumentUrl = '$cdnUrl/$objectName';
      });
      print('Upload réussi: $_identityDocumentUrl');
    } else {
      throw Exception('Erreur lors de l\'upload du fichier: ${streamedResponse.statusCode} - $responseBody');
    }
    
  } catch (e) {
    print('Erreur lors de l\'upload: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de l\'upload: $e')),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  // Valider et passer à l'écran suivant
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
          identityDocumentUrl: _identityDocumentUrl,
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