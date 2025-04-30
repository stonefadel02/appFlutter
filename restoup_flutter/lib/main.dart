import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:restoup_flutter/splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
Future<void> main() async {

  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Fond blanc pour tous les Scaffold
      ),
      
      home: const  Welcome(),
    );
  }
}



