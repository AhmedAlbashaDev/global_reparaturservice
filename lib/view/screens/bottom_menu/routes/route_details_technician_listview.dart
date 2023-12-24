import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/orders/drop_off_order_details_technicain.dart';
import 'package:global_reparaturservice/view/widgets/order_card.dart';
import 'package:url_launcher/url_launcher.dart';

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
                              return Column(
                                children: [
                                  OrderCard(
                                    orderIndex: index + 1,
                                    showOrderStatus: true,
                                    showOrderPaymentStatus: true,
                                    showOrderCheckBox: false,
                                    onPressed: () {
                                      if(orders[index].type != 3){
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => OrderDetailsTechnician(
                                                  orderId: orders[index].id,
                                                  routeId: routeId,
                                                )));
                                      }
                                      else{
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => DropOddOrderDetailsTechnician(
                                                  orderId: orders[index].id,
                                                  routeId: routeId,
                                                )));
                                      }
                                    },
                                    orderModel: orders[index],
                                  ),
                                  const SizedBox(height: 2,),
                                  SizedBox(
                                      height: 40,
                                      child: CustomButton(
                                        onPressed: () async {
                                          var name = Uri.encodeComponent(orders[index].address);
                                          name = name.replaceAll('%20', '+');
                                          String googleUrl = 'https://www.google.com/maps/place/$name/@${orders[index].lat},${orders[index].lng}';

                                          Uri url = Uri.parse(googleUrl);//order pdf file
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        text:
                                        'show_street'
                                            .tr(),
                                        textColor:
                                        Colors.white,
                                        bgColor: Theme.of(
                                            context)
                                            .primaryColor,
                                        icon: const Icon(Icons.map , color: Colors.white,),
                                        radius: 10,
                                      )
                                  ),
                                  const SizedBox(height: 5,),
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
