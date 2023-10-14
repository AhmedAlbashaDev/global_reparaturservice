import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/providers/selected_orders_new_order_provider.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/routes/new_route.dart';
import 'package:global_reparaturservice/view_model/route_view_model.dart';
import 'package:lottie/lottie.dart';

import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/order_card.dart';

class RouteDetailsAdmin extends ConsumerStatefulWidget {
  const RouteDetailsAdmin({super.key, required this.routeId});

  final int routeId;

  @override
  ConsumerState createState() => _RouteDetailsAdminState(routeId: routeId);
}

class _RouteDetailsAdminState extends ConsumerState<RouteDetailsAdmin> {
  _RouteDetailsAdminState({required this.routeId});

  final int routeId;

  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        ref.read(routeViewModelProvider.notifier).loadOne(routeId: routeId));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            Column(
              children: [
                CustomAppBar(
                  title: 'route_details'.tr(),
                ),
                ref.watch(routeViewModelProvider).maybeWhen(
                    loading: () => Expanded(
                      child: Center(
                        child: Lottie.asset(
                            'assets/images/global_loader.json',
                            height: 50),
                      ),
                    ),
                  data: (routeDetails) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10,),
                            AutoSizeText.rich(
                              TextSpan(
                                  text: 'selected_orders_for_this_route'.tr(),
                                  children:  [
                                    TextSpan(
                                        text: ' (${routeDetails.orders?.length})',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500))
                                  ]),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return OrderCard(
                                    orderModel: routeDetails.orders?[index],
                                    onPressed: null,
                                    showOrderStatus: true,
                                    showOrderCheckBox: false,
                                    showOrderPaymentStatus: true
                                );
                              },
                              itemCount: routeDetails.orders?.length,
                            ),

                            const SizedBox(height: 5,),

                            AutoSizeText(
                              'assigned_technician'.tr(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 10,),

                            routeDetails.driverId == null
                                ? SizedBox(
                              height: 50,
                              child: MaterialButton(
                                onPressed: (){},
                                child: AutoSizeText(
                                  'assign_driver'.tr(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            )
                                : Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFDBDBDB))
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/car.png', height: 30,),
                                      const SizedBox(width: 10,),
                                      AutoSizeText(
                                        '${routeDetails.driver?.name}',
                                        style: TextStyle(
                                            color:
                                            Theme.of(context).primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    );
                  },
                  error: (error) => CustomError(
                    message: error.errorMessage ?? '',
                    onRetry: () {
                      ref
                          .read(routeViewModelProvider.notifier)
                          .loadOne(routeId: routeId);
                    },
                  ),
                  orElse: () => Center(
                    child: CustomError(
                      message: 'unknown_error_please_try_again'.tr(),
                      onRetry: () {
                        ref
                            .read(routeViewModelProvider.notifier)
                            .loadOne(routeId: routeId);
                      },
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
