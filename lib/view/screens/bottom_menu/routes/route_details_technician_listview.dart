import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/view/widgets/order_card.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../../../core/globals.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/gradient_background.dart';
import '../orders/order_details_technician.dart';

class RouteDetailsTechnicianListView extends ConsumerWidget {
  const RouteDetailsTechnicianListView({super.key, required this.orders ,required this.routeId});

  final List<OrderModel> orders;
  final int routeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            Column(
              children: [
                CustomAppBar(
                  title: 'routes_details'.tr(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText.rich(
                          TextSpan(text: 'orders'.tr(), children:  [
                            TextSpan(
                                text: ' (${orders.length})',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500))
                          ]),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10,),
                        Expanded(
                          child: ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: OrderCard(
                                      showOrderStatus: true,
                                      showOrderPaymentStatus: true,
                                      showOrderCheckBox: false,
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => OrderDetailsTechnician(
                                                  orderId: orders[index].id,
                                                  routeId: routeId,
                                                )));
                                      },
                                      orderModel: orders[index],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: 40,
                                            child: CustomButton(
                                                onPressed: () {
                                                  MapsLauncher.launchCoordinates(
                                                      double.parse(
                                                          orders[index]
                                                              .lat),
                                                      double.parse(
                                                          orders[index]
                                                              .lng),
                                                      orders[index]
                                                          .address);
                                                },
                                                text:
                                                'show_street'
                                                    .tr(),
                                                textColor:
                                                Colors.white,
                                                bgColor: Theme.of(
                                                    context)
                                                    .primaryColor,
                                            icon: const Icon(Icons.map , color: Colors.white,),)),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
