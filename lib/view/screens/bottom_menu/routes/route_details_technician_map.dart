import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/orders/drop_off_order_details_technicain.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/routes/route_details_technician_listview.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';
import 'package:global_reparaturservice/view/widgets/custsomer_card_new_order.dart';
import 'package:global_reparaturservice/view_model/finish_route_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../view_model/route_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/gradient_background.dart';
import '../orders/order_details_technician.dart';
import 'finished_route.dart';

final selectedOrder = StateProvider<int?>((ref) => null);
final isAllOrdersFinished = StateProvider.autoDispose<bool?>((ref) => true);
final isFinishedRouteProvider = StateProvider.autoDispose<bool>((ref) => false);

class RouteDetailsTechnician extends ConsumerStatefulWidget {
  const RouteDetailsTechnician({super.key, required this.routeId});

  final int routeId;

  @override
  ConsumerState createState() => _RouteDetailsTechnicianState(routeId: routeId);
}

class _RouteDetailsTechnicianState
    extends ConsumerState<RouteDetailsTechnician> {
  _RouteDetailsTechnicianState({required this.routeId});

  final int routeId;

  GoogleMapController? mapController;

  final Map<String, Marker> _markers = {};

  BitmapDescriptor? completed;
  BitmapDescriptor? completedSelected;
  BitmapDescriptor? pendingSelected;
  BitmapDescriptor? pending;

  List<LatLng> polyLinePoints = [];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(routeViewModelProvider.notifier).loadOne(routeId: routeId);
      ref.read(selectedOrder.notifier).state = null;
    });

    _markers.clear();

    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(30, 30)), 'assets/images/completed.png')
        .then((onValue) {
      completed = onValue;
    });

    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(30, 30)), 'assets/images/completed_selected.png')
        .then((onValue) {
      completedSelected = onValue;
    });


    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 30)), 'assets/images/pending.png')
        .then((onValue) {
      pending = onValue;
    });


    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(30, 30)), 'assets/images/pending_selected.png')
        .then((onValue) {
      pendingSelected = onValue;
    });

  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
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
                              height: 50),
                        ),
                      ),
                      data: (routeDetails) {

                        routeDetails.orders?.asMap().forEach((index, order) {

                          BitmapDescriptor? bitmapDescriptor;

                          if(order.type == 3){
                            if(order.status == 4){
                              bitmapDescriptor = (ref.watch(selectedOrder) == order.id ? completedSelected : completed);
                            }
                            else{
                              bitmapDescriptor = (ref.watch(selectedOrder) == order.id ? pendingSelected  : pending);
                            }
                          }
                          else{
                            if(order.status > 2){
                              bitmapDescriptor = (ref.watch(selectedOrder) == order.id ? completedSelected : completed);
                            }
                            else{
                              bitmapDescriptor = (ref.watch(selectedOrder) == order.id ? pendingSelected  : pending);
                            }

                          }

                          if(order.type == 3){
                            if (order.status != 4) {
                              Future.microtask(() {
                                ref.read(isAllOrdersFinished.notifier).state = false;
                              });
                            }
                          }
                          else{
                            if (order.status > 0 && order.status < 3) {
                              Future.microtask(() {
                                ref.read(isAllOrdersFinished.notifier).state = false;
                              });
                            }
                          }

                          LatLng position = LatLng(order.lat, order.lng);

                          final marker = Marker(
                            markerId: MarkerId(order.referenceNo),
                            onTap: () {
                              ref
                                  .read(selectedOrder.notifier)
                                  .state = order.id;
                              showModalBottomSheet(
                                  context: context,
                                  useSafeArea: true,
                                  backgroundColor:
                                  Colors.transparent,
                                  builder: (context) {
                                    return Container(
                                      height: 220,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10)),
                                      margin:
                                      const EdgeInsets.all(10),
                                      padding:
                                      const EdgeInsets.all(6),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceAround,
                                        children: [
                                          CustomerCardNewOrder(
                                            empty: false,
                                            isOnMap: true,
                                            orderPhone: order
                                                .orderPhoneNumber,
                                            userModel:
                                            order.customer,
                                            isOrderDetails: true,
                                          ),
                                          SizedBox(
                                              height: 40,
                                              width:
                                              screenWidth * 70,
                                              child: CustomButton(
                                                  icon: const Icon(Icons.map , color: Colors.white,),
                                                  onPressed: () async {
                                                    var name = Uri.encodeComponent(order.address);
                                                    name = name.replaceAll('%20', '+');
                                                    String googleUrl = 'https://www.google.com/maps/place/$name/@${order.lat},${order.lng}';

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
                                                      .primaryColor)),
                                          SizedBox(
                                              height: 40,
                                              width:
                                              screenWidth * 70,
                                              child: CustomButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context);
                                                    if(order.type == 3){
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => DropOddOrderDetailsTechnician(
                                                                orderId: order.id,
                                                                routeId: routeId,
                                                              )));
                                                    }
                                                    else{
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => OrderDetailsTechnician(
                                                                orderId: order.id,
                                                                routeId: routeId,
                                                              )));
                                                    }
                                                  },
                                                  text:
                                                  'order_details'
                                                      .tr(),
                                                  textColor:
                                                  Colors.white,
                                                  bgColor: Theme.of(
                                                      context)
                                                      .primaryColor)),
                                        ],
                                      ),
                                    );
                                  });
                            }, // Her
                            position: position,
                            icon:  bitmapDescriptor ?? BitmapDescriptor.defaultMarker,
                            //BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow)),
                            infoWindow: InfoWindow(
                              title: '#${index+1}',
                              snippet: order.statusName,
                            ),
                          );

                          _markers[order.referenceNo] = marker;

                          polyLinePoints.add(position);
                        });

                        return Expanded(
                          child: Stack(
                            children: [
                              GoogleMap(
                                onMapCreated: (GoogleMapController controller) {
                                  mapController = controller;
                                },

                                initialCameraPosition: CameraPosition(
                                  target: routeDetails.orders?.isEmpty ?? false ? LatLng(double.parse(centerLat), double.parse(centerLng)) : LatLng(
                                      routeDetails.orders!.first.lat,
                                      routeDetails.orders!.first.lng
                                  ),
                                  zoom: 8,
                                ),
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: true,
                                markers: _markers.values.toSet(),
                                // polylines: {
                                //   Polyline(
                                //     polylineId: PolylineId('$routeId'),
                                //     points: polyLinePoints,
                                //     color: Theme.of(context).primaryColor.withOpacity(.5),
                                //     width: 1,
                                //       // polygonId: PolygonId("$routeId",),
                                //       // points: polyLinePoints,
                                //       // strokeWidth: 2,
                                //       // strokeColor: Theme.of(context).primaryColor.withOpacity(.6),
                                //       // fillColor: Theme.of(context).primaryColor.withOpacity(.5)
                                //   )
                                // },
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 45,
                                    margin: const EdgeInsets.all(20),
                                    width: screenWidth * 90,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => RouteDetailsTechnicianListView(orders: routeDetails.orders ?? [] , routeId: routeId,)));
                                            },
                                            text: 'Route Orders ListView'.tr(),
                                            textColor: Colors.white,
                                            bgColor: Theme.of(context).primaryColor.withOpacity(.9),
                                            icon: const Icon(Icons.view_list , color: Colors.white,size: 30,),
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        CircleAvatar(
                                          backgroundColor: Colors.white.withOpacity(.6),
                                            radius: 22,
                                            child: IconButton(onPressed: (){
                                              ref.read(routeViewModelProvider.notifier).getLocation().then((position){
                                                mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude , position.longitude) , zoom: 13)));
                                              });
                                            },
                                              icon: const Icon(Icons.my_location , size: 25,),
                                              color: Theme.of(context).primaryColor,),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 55,
                                    margin: const EdgeInsets.all(20),
                                    width: screenWidth * 90,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: SwipeableButtonView(
                                          isActive: routeDetails.status == 3
                                              ? false
                                              : (ref.watch(isAllOrdersFinished) ?? false),
                                          buttonText:
                                              'slide_to_finish'.tr(),
                                          buttontextstyle: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                          buttonWidget: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          isFinished: ref
                                              .watch(isFinishedRouteProvider),
                                          onWaitingProcess: () {
                                            ref
                                                .read(
                                                    finishRouteViewModelProvider
                                                        .notifier)
                                                .finishRoute(routeId: routeId);
                                          },
                                          onFinish: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child:
                                                        const FinishedRouteScreen()));

                                            ref
                                                .read(isFinishedRouteProvider
                                                    .notifier)
                                                .state = false;
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
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
