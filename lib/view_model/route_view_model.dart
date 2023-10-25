import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_reparaturservice/models/order.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/response_state.dart';
import '../models/routes.dart';
import '../repositories/routes_repository.dart';

final routeViewModelProvider = StateNotifierProvider.autoDispose<RouteViewModel,ResponseState<RoutesModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return RouteViewModel(RoutesRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class RouteViewModel extends StateNotifier<ResponseState<RoutesModel>> {
  final RoutesRepository routesRepository;

  RouteViewModel(this.routesRepository) : super(const ResponseState<RoutesModel>.idle());

  Future<void> loadOne({required int routeId}) async{

    setState(const ResponseState<RoutesModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await routesRepository.loadOne(endPoint: 'roads/$routeId');

    response.whenOrNull(data: (data) {
      state = ResponseState<RoutesModel>.data(data: data);
    }, error: (error) {
      state = ResponseState<RoutesModel>.error(error: error);
    });

    response.whenOrNull(data: (data) {
      setState(ResponseState<RoutesModel>.data(data: data));
    }, error: (error) {
      setState(ResponseState<RoutesModel>.error(error: error));
    });
  }

  Future<void> create({required String description,required int? driverId,required List<OrderModel?> orders}) async {


    setState(const ResponseState<RoutesModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    List<int?> ordersIDs = [];

    for (var order in orders) {
      ordersIDs.add(order?.id);
    }

    final response = await routesRepository.create(description: description, driverId: driverId, ordersIDs: ordersIDs);

    response.whenOrNull(success: (data) {
      setState(ResponseState<RoutesModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<RoutesModel>.error(error: error));
    });
  }

  Future<void> update({required int? routeId, required String description,required int? driverId,required List<OrderModel?> orders}) async {


    setState(const ResponseState<RoutesModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    List<int?> ordersIDs = [];

    for (var order in orders) {
      ordersIDs.add(order?.id);
    }

    final response = await routesRepository.update(
        routeId: routeId,
        data: {
          'description' : description,
          'driver_id' : driverId,
          'orders_ids[]' : ordersIDs,
        }
    );

    response.whenOrNull(success: (data) {
      setState(ResponseState<RoutesModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<RoutesModel>.error(error: error));
    });
  }

  Future<Position> getLocation() async {
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  Future<Uint8List> getBytesFromAsset(String path, int size) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: size , targetHeight: size);
    FrameInfo fi = await codec.getNextFrame();
    Uint8List value =  (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
    print('Uint*List value is : $value');
    return value;

  }

  setState(ResponseState<RoutesModel> newState){
    // if(mounted) {
      state = newState;
    // }
  }

}