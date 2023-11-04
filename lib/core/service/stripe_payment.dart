import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:global_reparaturservice/core/providers/dio_network_provider.dart';

import '../../models/order.dart';
import '../../view_model/order_view_model.dart';

final paymentLoadingProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

class StripePaymentService {
  static dynamic paymentIntent;

  static late WidgetRef ref;

  static Future<String?> makePayment(
      {required String amount,
      required String currency,
      required OrderModel? order,
      required WidgetRef refProvider}) async {
    try {
      //STEP 1: Create Payment Intent
      ref = refProvider;

      ref.read(paymentLoadingProvider.notifier).state = true;

      paymentIntent = await createPaymentIntent(double.parse(amount), currency);

      // //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  billingDetailsCollectionConfiguration: const BillingDetailsCollectionConfiguration(
                    address: AddressCollectionMode.never,
                  ),
                  paymentIntentClientSecret: paymentIntent?['client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet().then((value) async {
        final paymentId = await getPaymentDetails(paymentIntent?['id']);
        if (paymentId.isNotEmpty) {
          ref
              .read(orderViewModelProvider
              .notifier)
              .updatePayment(
              orderId: order!.id,
              paymentId:
              paymentId,
              paymentWay:
              2);
        }
      });
    } catch (err) {
      throw Exception(err);
      ref.read(paymentLoadingProvider.notifier).state = false;
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
      ref.read(paymentLoadingProvider.notifier).state = false;
    }
  }

  static Future displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      ref.read(paymentLoadingProvider.notifier).state = false;
    } catch (e) {
      print('$e');
      ref.read(paymentLoadingProvider.notifier).state = false;
    }
  }

  static Future<String> getPaymentDetails(String paymentIntentId) async {
    try {

      final dioClient = ref.read(dioClientNetworkProvider);

      var response = await dioClient.get(
        'payment-info?payment_intent=$paymentIntentId',
      );

      print('The payment id ${response.data['data'][0]['id']}');

      return response.data['data'][0]['id'];

    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
