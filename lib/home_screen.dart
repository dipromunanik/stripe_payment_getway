import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String,dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: (){
                makePayment();
              },
              child: Text('Add Cart'),
            )
          ],
        ),
      ),
    );
  }

 Future<void> makePayment() async{
    try{
      paymentIntentData =await createPaymentIntent('20','USD');

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              applePay: true,
              googlePay: true,
              testEnv: true,
              style: ThemeMode.dark,
              merchantCountryCode: 'US',
              merchantDisplayName: 'ANNIE')).then((value){
      });


      displayPaymentSheet();

    }catch(e){
      print('eception'+e.toString());
    }
  }

  createPaymentIntent(String amount, String currency)async {

    try{
      Map<String,dynamic> body ={
        'amount':calculateAmount(amount),
        'currency':currency,
        'payment_method_types[]':'card'
      };

      var response =await http.post(Uri.parse('https://api.stripe.com/v1/payment_intent'),
        body: body,
        headers: {
        'Authorization':'Bearer sk_test_51L9QiWC3y5xC1p9PP5aocGJFviz2LcvaSKx2jJkrkkNJ3XQwYnGhjtl9DzWigaLQPVIEy2rmBmNhxG17Juu5Kxyp00KHbihPJp',
          'Content-Type': 'application/x-www-form-urlencoded'
        }

      );
      return jsonDecode(response.body.toString());
    }catch(e){
      print('eception'+e.toString());
    }

  }

  calculateAmount(String amount) {
    final price =int.parse(amount)*100;
    return price;
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntentData!['client_secret'],
            confirmPayment: true,
          )).then((newValue){


        print('payment intent'+paymentIntentData!['id'].toString());
        print('payment intent'+paymentIntentData!['client_secret'].toString());
        print('payment intent'+paymentIntentData!['amount'].toString());
        print('payment intent'+paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("paid successfully")));

        paymentIntentData = null;

      }).onError((error, stackTrace){
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });


    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

  }
