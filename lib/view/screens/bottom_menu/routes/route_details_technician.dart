import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';
import 'package:global_reparaturservice/view/widgets/custsomer_card_new_order.dart';
import 'package:global_reparaturservice/view_model/finish_route_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';


import '../../../../view_model/route_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/gradient_background.dart';
import '../orders/order_details_technician.dart';
import 'finished_route.dart';


final selectedOrder = StateProvider<int?>((ref) => null);
final isAllOrdersFinished = StateProvider.autoDispose<bool?>((ref) => null);
final isFinishedRouteProvider = StateProvider.autoDispose<bool>((ref) => false);

class RouteDetailsTechnician extends ConsumerStatefulWidget {
  const RouteDetailsTechnician({super.key ,required this.routeId});

  final int routeId;

  @override
  ConsumerState createState() => _RouteDetailsTechnicianState(routeId: routeId);
}

class _RouteDetailsTechnicianState extends ConsumerState<RouteDetailsTechnician> {
  _RouteDetailsTechnicianState({required this.routeId});

  final int routeId;

  late GoogleMapController mapController;

  LatLng _center =  const LatLng(37.42796133580664, -122.085749655962);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  late List<MarkerData> _customMarkers;


  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(routeViewModelProvider.notifier).loadOne(routeId: routeId);
      ref.read(selectedOrder.notifier).state = null;
    }
    );

    _customMarkers = [];

  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
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
                  title: 'routes_details'.tr(),
                ),
                ref.watch(routeViewModelProvider).maybeWhen(
                  loading: () => Expanded(
                    child: Center(
                      child: lottie.Lottie.asset(
                          'assets/images/global_loader.json',
                          height: 50
                      ),
                    ),
                  ),
                  data: (routeDetails) {

                    if(routeDetails.orders?.isNotEmpty ?? false){
                      _center = LatLng(double.parse(routeDetails.orders?.last.lat ?? "0.0"), double.parse(routeDetails.orders?.last.lng ?? "0.0"));
                    }

                    for (OrderModel order in (routeDetails.orders ?? [])) {
                      if(order.status != 3){
                        Future.microtask(() {
                          ref.read(isAllOrdersFinished.notifier).state = false;
                        });
                      }
                      final marker = MarkerData(
                          marker: Marker(
                              markerId: MarkerId(order.referenceNo),
                              position: LatLng(double.parse(order.lat) , double.parse(order.lng)),
                              onTap: (){
                                ref.read(selectedOrder.notifier).state = order.id;
                                showModalBottomSheet(
                                    context: context,
                                    useSafeArea: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context){
                                      return Container(
                                        height: 220,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.all(6),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            CustomerCardNewOrder(
                                              empty: false,
                                              isOnMap: true,
                                              orderPhone: order.orderPhoneNumber,
                                              userModel: order.customer,
                                              isOrderDetails: true,
                                            ),

                                            SizedBox(
                                                height: 40,
                                                width: screenWidth * 70,
                                                child: CustomButton(onPressed: (){}, text: 'show_street'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor)),

                                            SizedBox(
                                                height: 40,
                                                width: screenWidth * 70,
                                                child: CustomButton(onPressed: (){
                                                  Navigator.pop(context);
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderDetailsTechnician(orderId: order.id,routeId: routeId,)));
                                                }, text: 'order_details'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor)),
                                          ],
                                        ),
                                      );
                                    }
                                );
                              }, // Here you can implement on marker tap
                          ),
                          child: CustomMarkerWidget(
                            id: order.id,
                            isSelected: ref.watch(selectedOrder) == order.id,
                            isDone: order.status == 3 ? true : false,
                          ),
                      );
                      _customMarkers.add(marker);
                    }

                    if(ref.read(isAllOrdersFinished) == null){
                      Future.microtask(() {
                        ref.read(isAllOrdersFinished.notifier).state = true;
                      });
                    }

                    return Expanded(
                      child: Stack(
                        children: [
                          CustomGoogleMapMarkerBuilder(
                            customMarkers: _customMarkers,
                            screenshotDelay: const Duration(microseconds: 100),
                            builder: (BuildContext context, Set<Marker>? markers) {
                              if (markers == null) {
                                return  Center(
                                  child: lottie.Lottie.asset(
                                      'assets/images/global_loader.json',
                                      height: 50
                                  )
                                );
                              }
                              return GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: _center,
                                  zoom: 14,
                                ),
                                // zoomControlsEnabled: false,
                                markers: markers
                              );
                            },
                          ),
                          SizedBox(
                            height: routeDetails.status == 3 ? 0 : ref.watch(isAllOrdersFinished) ?? true ? screenHeight * 100 : 0,
                            width: screenWidth * 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 55,
                                  margin: const EdgeInsets.all(20),
                                  width: screenWidth * 90,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                      child: SwipeableButtonView(
                                        buttonText: 'slide_to_finish_this_route'.tr(),
                                        buttontextstyle: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                        buttonWidget: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        activeColor: Theme.of(context).primaryColor,
                                        isFinished: ref.watch(isFinishedRouteProvider),
                                        onWaitingProcess: () {
                                          ref.read(finishRouteViewModelProvider.notifier).finishRoute(routeId: routeId);
                                        },
                                        onFinish: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: const FinishedRouteScreen()));

                                          ref.read(isFinishedRouteProvider.notifier).state = false;
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  error: (error) => CustomError(
                    message: error.errorMessage ?? '',
                    onRetry: (){
                      ref.read(routeViewModelProvider.notifier).loadOne(routeId: routeId);
                    },
                  ),
                  orElse: () => Center(
                    child: CustomError(
                      message: 'unknown_error_please_try_again'.tr(),
                      onRetry: (){
                        ref.read(routeViewModelProvider.notifier).loadOne(routeId: routeId);
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

class CustomMarkerWidget extends StatelessWidget {
  const CustomMarkerWidget({super.key ,required this.id , required this.isDone , required this.isSelected});

  final int? id;
  final bool? isSelected;
  final bool? isDone;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MessageClipper(borderRadius: 4),
      child: Container(
        height: 40,
        width: 80,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: isSelected == true ? const Color(0xff224D6F) : Colors.grey.shade300,
            border: Border.all(color: const Color(0xff224D6F) , width: 1),
        ),
        child:   Column(
          children: [
            const SizedBox(height: 2,),
            Row(
              children: [
                const SizedBox(width: 5,),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: isDone ?? false ? Colors.green : Colors.amberAccent,
                ),
                const SizedBox(width: 10,),
                AutoSizeText(
                  '#$id',
                  style: TextStyle(
                      color: isSelected == true ? Colors.white : const Color(0xff224D6F),
                      fontWeight: FontWeight.w600
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

