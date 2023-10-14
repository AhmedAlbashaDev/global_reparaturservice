import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/models/routes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../../../../view_model/route_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/gradient_background.dart';
import '../orders/order_details_technician.dart';

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

  LatLng _center =  LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
      ref.read(routeViewModelProvider.notifier).loadOne(routeId: routeId)
    );

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

                    _markers.clear();

                    for (OrderModel order in routeDetails.orders ?? []) {
                      final marker = Marker(
                        markerId: MarkerId(order.referenceNo),
                        position: LatLng(double.parse(order.lat), double.parse(order.lng)),
                        infoWindow: InfoWindow(
                          title: order.referenceNo,
                          snippet: order.address,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsTechnician(orderId: order.id,)));
                          }
                        ),
                      );
                      _markers[order.referenceNo] = marker;
                    }

                    return Expanded(
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 11.0,
                        ),
                        markers: _markers.values.toSet(),
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
