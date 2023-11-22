import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:global_reparaturservice/models/order.dart';
import 'package:global_reparaturservice/models/routes.dart';
import 'package:global_reparaturservice/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../../../widgets/custom_app_bar.dart';

class TrackTechnician extends ConsumerStatefulWidget {
  const TrackTechnician({super.key ,this.routesModel , this.techniciansList});

  final RoutesModel? routesModel;
  final List<UserModel>? techniciansList;

  @override
  ConsumerState createState() => _TrackTechnicianState(routesModel: routesModel , techniciansList: techniciansList);
}

class _TrackTechnicianState extends ConsumerState<TrackTechnician> {
  _TrackTechnicianState({required this.routesModel , this.techniciansList});
  final RoutesModel? routesModel;
  final List<UserModel>? techniciansList;

  late GoogleMapController mapController;

  final Map<String, Marker> _markers = {};

  List<LatLng> polyLinePoints = [];

  BitmapDescriptor? completed;
  BitmapDescriptor? pending;
  BitmapDescriptor? technician;


  bool isLoading = true;

  Future<void> configureMap() async {

    if(techniciansList == null){
      completed  = await  BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 30)), 'assets/images/completed.png');

      pending    = await  BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 30)), 'assets/images/pending.png');

      technician = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 30)), 'assets/images/technician.png');

      for(OrderModel order in routesModel?.orders ?? []){
        LatLng position = LatLng(order.lat, order.lng);

        final marker = Marker(
          markerId: MarkerId(order.referenceNo),
          position: position,
          icon: (order.status == 3
              ? completed
              : pending) ?? BitmapDescriptor.defaultMarker,
          //BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow)),
          infoWindow: InfoWindow(
            title: '#${order.id}',
            snippet: order.statusName,
          ),
        );
        _markers[order.referenceNo] = marker;

        polyLinePoints.add(position);
      }

      LatLng driverPosition = LatLng(routesModel?.driver?.lat ?? double.parse(centerLat), routesModel?.driver?.lng ?? double.parse(centerLng));

      final marker = Marker(
        markerId: MarkerId('${routesModel?.referenceNo}'),
        position: driverPosition,
        icon: technician ?? BitmapDescriptor.defaultMarker,
      );

      _markers['${routesModel?.referenceNo}'] = marker;
      polyLinePoints.add(driverPosition);
    }
    else{

      technician = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 30)), 'assets/images/technician.png');

      for(UserModel technicianObject in techniciansList ?? []){

        LatLng position = LatLng(technicianObject.lat ?? 0, technicianObject.lng ?? 0);

        final marker = Marker(
          markerId: MarkerId('${technicianObject.id}'),
          position: position,
          icon: technician ?? BitmapDescriptor.defaultMarker,
          //BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow)),
          infoWindow: InfoWindow(
            title: '#${technicianObject.name}',
            snippet: technicianObject.phone,
          ),
        );
        _markers['${technicianObject.id}'] = marker;

        polyLinePoints.add(position);

      }
    }

    setState(() {
      isLoading = false;
    });

  }

  @override
  void initState(){
    super.initState();

    configureMap();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Track Technician'.tr(),
            ),
            isLoading ? Expanded(
              child: Center(
                child: lottie.Lottie.asset(
                    'assets/images/global_loader.json',
                    height: 50),
              ),
            ) : Expanded(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target:techniciansList == null
                      ? LatLng(routesModel?.driver?.lat ?? double.parse(centerLat), routesModel?.driver?.lng ?? double.parse(centerLng))
                      : techniciansList?.isEmpty ?? false? LatLng(double.parse(centerLat),double.parse(centerLng)) : LatLng(techniciansList?.first.lat ?? double.parse(centerLat), techniciansList?.first.lng ?? double.parse(centerLng)),
                  zoom: 10,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: true,
                markers: _markers.values.toSet(),
                polygons: {
                  if(polyLinePoints.isNotEmpty)
                    Polygon(
                        polygonId: const PolygonId("technicians"),
                        points: polyLinePoints,
                        strokeWidth: 2,
                        strokeColor: Theme.of(context).primaryColor.withOpacity(.6),
                        fillColor: Theme.of(context).primaryColor.withOpacity(.6)
                    )
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
