import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:global_reparaturservice/core/providers/dio_network_provider.dart';

final paymentLoadingProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

class StripePaymentService {
  static dynamic paymentIntent;

  static late WidgetRef ref;

  static Future<String> makePayment(
      {required String amount,
      required String currency,
      required WidgetRef refProvider}) async {
    try {
      //STEP 1: Create Payment Intent
      ref = refProvider;

      ref.read(paymentLoadingProvider.notifier).state = true;

      paymentIntent = await createPaymentIntent(100, currency);

      // //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent?['client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      await displayPaymentSheet();
      print('Payment Intent Id : ${paymentIntent?['id']}');
      final paymentId = await getPaymentDetails(paymentIntent?['id']);
      return paymentId;
    } catch (err) {
      throw Exception(err);
    }
  }

  static createPaymentIntent(double amount, String currency) async {
    try {
      Map<String, dynamic> data = {
        'amount': (amount * 100)
            .toInt()
            .toString(), // * 100 its stripe requirement the actual amount will pay is the amount value displayed in order screen
        'currency': currency,
      };

      final dioClient = ref.read(dioClientNetworkProvider);

      var response = await dioClient.post(
        'payment-intents',
        data: data,
      );

      return response.data;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  static displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
    } catch (e) {
      print('$e');
    }
  }

  static Future<String> getPaymentDetails(String paymentIntentId) async {
    try {

      final dioClient = ref.read(dioClientNetworkProvider);

      var response = await dioClient.get(
        'payment-info?payment_intent=$paymentIntentId',
      );

      return response.data['data'][0]['id'];

    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
