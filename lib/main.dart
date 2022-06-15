import 'package:flutter/material.dart';
import 'package:flutter_payment_getway/home_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey ='pk_test_51L9QiWC3y5xC1p9PyHnfeQclNKrKFBy0rWHBctxBU38nEutOWEn3SA1xHZlrXJiy51Qh630OSNpkWeIAqu3deNH600MuYAiYVg';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink
      ),
      home: HomeScreen(),
    );
  }
}
