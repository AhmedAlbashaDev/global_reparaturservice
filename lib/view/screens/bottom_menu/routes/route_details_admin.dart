import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/routes.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/routes/choose_technician.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/routes/track_technician.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';
import 'package:global_reparaturservice/view_model/route_view_model.dart';
import 'package:global_reparaturservice/view_model/routes_view_model.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/response_state.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/order_card.dart';
import '../orders/order_details_admin.dart';
import 'new_route.dart';


class RouteDetailsAdmin extends ConsumerStatefulWidget {
  const RouteDetailsAdmin({super.key, required this.routeId});

  final int routeId;

  @override
  ConsumerState createState() => _RouteDetailsAdminState(routeId: routeId);
}

class _RouteDetailsAdminState extends ConsumerState<RouteDetailsAdmin> with TickerProviderStateMixin {
  _RouteDetailsAdminState({required this.routeId});

  final int routeId;

  late AnimationController animationTech;
  late TextEditingController searchControllerTech;


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(routeViewModelProvider.notifier).loadOne(routeId: routeId);
    });

    searchControllerTech = TextEditingController();
    animationTech = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    animationTech.dispose();
    searchControllerTech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.listen<ResponseState<RoutesModel>>(routeViewModelProvider, (previous, next) {
      next.whenOrNull(
        success: (order) {

          if(ModalRoute.of(context)?.isCurrent != true){
            Navigator.pop(context);
          }

          ref.read(routeViewModelProvider.notifier).loadOne(routeId: routeId);
          ref.read(routesViewModelProvider.notifier).loadAll();

        },
        error: (error) {

          if(ModalRoute.of(context)?.isCurrent != true){
            Navigator.pop(context);
          }

          AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              title: 'Error'.tr(),
              desc: error.errorMessage,
              autoDismiss: false,
              dialogBackgroundColor: Colors.white,
              btnCancel: CustomButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                radius: 10,
                text: 'Ok'.tr(),
                textColor: Colors.white,
                bgColor: const Color(0xffd63d46),
                height: 40,
              ),
              onDismissCallback: (dismiss) {})
              .show();
        },
      );
    });

    return Scaffold(
      key: _scaffoldKey,
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
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: const Color(0xffDCDCDC))),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      'route_status'.tr(),
                                      style:  TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    AutoSizeText(
                                      routeDetails.statusName,
                                      style:  TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText.rich(
                                    TextSpan(
                                        text: 'orders'.tr(),
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
                                  if(routeDetails.status != 3)
                                  IconButton(
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => NewRouteScreen(isUpdate: true,routesModel: routeDetails,))
                                      );
                                    },
                                    icon: Icon(
                                      Icons.add_box_rounded,
                                      color: Theme.of(context)
                                          .primaryColor,
                                      size: 35,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 40,
                                child: CustomButton(
                                    onPressed: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => TrackTechnician(routesModel: routeDetails,)));
                                    }, text: 'Map View'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return OrderCard(
                                    orderIndex: index + 1,
                                      scaffoldContext: _scaffoldKey.currentContext,
                                      orderModel: routeDetails.orders?[index],
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsAdmin(orderId: routeDetails.orders![index].id,)));
                                      },
                                      showOrderStatus: true,
                                      showOrderCheckBox: false,
                                      showOrderPaymentStatus: true,
                                      route: routeDetails,
                                  );
                                },
                                itemCount: routeDetails.orders?.length,
                              ),
                              const SizedBox(height: 5,),
                              AutoSizeText(
                                'technician'.tr(),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 20,),

                              routeDetails.driverId == null
                                  ? SizedBox(
                                height: 50,
                                child: CustomButton(
                                  onPressed: (){
                                    Navigator.push(context , MaterialPageRoute(builder: (context) => ChooseTechnician(driverId: routeDetails.driver?.id,))).then((value) {
                                      if(value == true){
                                        ref.read(routeViewModelProvider.notifier).update(routeId: widget.routeId, driverId: ref.watch(selectedTechnician)?.id, orders: routeDetails.orders ?? []);
                                      }
                                    });
                                  },
                                  text: 'assign_driver'.tr(),
                                  textColor: Colors.white,
                                  bgColor: Theme.of(context).primaryColor,
                                )
                              )
                                  : Column(
                                    children: [
                                      Container(
                                height: 70,
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
                                        Center(
                                          child: Container(
                                            width: 90,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: IconButton(
                                              onPressed: () async{
                                                final Uri launchUri = Uri(
                                                  scheme: 'tel',
                                                  path: '${routeDetails.driver?.phone}',
                                                );
                                                await launchUrl(launchUri);
                                              },
                                              color: Theme.of(context).primaryColor,
                                              icon:  const Icon(Icons.call_rounded),
                                            ),
                                          ),
                                        )
                                      ],
                                ),
                              ),
                                      const SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomButton(
                                                onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => TrackTechnician(routesModel: routeDetails,)));
                                              },
                                                radius: 8,
                                                text: 'Location'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor
                                            ),
                                          ),
                                         if(routeDetails.status != 3)
                                         Expanded(
                                           child: Row(
                                             children: [
                                               const SizedBox(width: 5,),
                                               Expanded(
                                                 child: CustomButton(
                                                     onPressed: (){
                                                       Navigator.push(context , MaterialPageRoute(builder: (context) => ChooseTechnician(driverId: routeDetails.driver?.id,))).then((value) {
                                                         if(value == true){
                                                           ref.read(routeViewModelProvider.notifier).update(routeId: widget.routeId, driverId: ref.watch(selectedTechnician)?.id, orders: routeDetails.orders ?? []);
                                                         }
                                                       });
                                                     },
                                                     radius: 8,
                                                     text: 'Change'.tr(),
                                                     textColor: Colors.white,
                                                     bgColor: Theme.of(context).primaryColor
                                                 ),
                                               ),
                                             ],
                                           ),
                                         )
                                        ],
                                      )
                                    ],
                                  ),

                              const SizedBox(height: 20,),
                            ],
                          ),
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
