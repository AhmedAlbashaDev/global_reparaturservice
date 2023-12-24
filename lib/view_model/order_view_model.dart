import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../core/providers/dio_network_provider.dart';
import '../models/order.dart';
import '../models/response_state.dart';
import '../repositories/orders_respository.dart';

final orderViewModelProvider = StateNotifierProvider.autoDispose<OrderViewModel,ResponseState<OrderModel>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return OrderViewModel(OrdersRepository(dioClient: ref.read(dioClientNetworkProvider) , ref: ref));
});

class OrderViewModel extends StateNotifier<ResponseState<OrderModel>> {
  final OrdersRepository ordersRepository;
   OrderViewModel(this.ordersRepository) : super(const ResponseState<OrderModel>.idle());

  Future<void> create({required String maintenanceDevice ,required String brand ,required String description ,required String address ,required String floorNumber ,required String additionalInfo ,required int? customerId , required double? lat , required double? lng , required String? phone , required String? postalCode , required String? city , required String? zone , required String? visitTime}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    Map data = {
      'maintenance_device' : maintenanceDevice,
      'brand' : brand,
      'problem_summary' : description,
      'address' : address,
      'customer_id' : customerId,
      'lat' : lat,
      'lng' : lng,
      'city' : city,
      'postal_code' : postalCode,
      'zone' : zone,
      'floor_number' : floorNumber,
      'order_phone_number' : phone,
      'additional_info' : additionalInfo,
      "visit_time" : visitTime,
    };

    final response = await ordersRepository.create(endPoint: 'orders', data: data);

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> pickUpOrder({required int orderId , required int type ,required String brand ,required String information ,required List<int>? devices ,required List<int> questions ,required List<Item> items ,required double? maxMaintenancePrice ,required double? paidAmount , required int paymentWay , required bool isAmountReceived , required bool isCustomerConfirm , required int orderMode}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    Map data = {
      'type' : type,
      'information' : information,
      'order_mode' : orderMode,
      'brand' : brand,
      'devices' : devices,
      'questions' : questions,
      'items' : items,
      'max_maintenance_price' : maxMaintenancePrice,
      'is_amount_received' : isAmountReceived,
      'is_customer_confirm' : isCustomerConfirm,
    };

    if((paidAmount ?? 0.0) > 0){
      data['paid_amount'] = paidAmount;
      data['payment_way'] = paymentWay;
    }

    final response = await ordersRepository.create(endPoint: 'orders/add-pickup/$orderId', data: data);

    response.whenOrNull(success: (data) {
      setState(const ResponseState<OrderModel>.success(data: {'update_order' : true}));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> dropOffOrder({required String referenceNumber ,required bool withRoute , required String? visitTime,
  required int guaranteeId, required String companyName, required String name, required String address, required String postalCode,
  required String partOfBuilding, required String phone,required String information
  }) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));


    final response = await ordersRepository.create(endPoint: 'orders/add-drop-off' ,data:
      {
        "reference_no"    : referenceNumber,
        "with_route"      : withRoute,
        "guarantee_id"    : guaranteeId,
        "company_name"    : companyName,
        "name"            : name,
        "address"         : address,
        "postal_code"     : postalCode,
        "part_of_building": partOfBuilding,
        "visit_time"      : visitTime,
        "phone"           : phone,
        "information"     : information,
      }
    );

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: {'with_route' : withRoute}));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> updatePayment({required int orderId , required int paymentWay, required String report , required bool isDropOff}) async{

    setState(const ResponseState<OrderModel>.loading());

    ordersRepository.update(
      orderId: orderId,
      data: {
        "payment_way" : paymentWay,
      },
    ).then((value) {
      value.whenOrNull(
        success: (data){
          if(isDropOff){
            finishDropOffOrder(orderId: orderId, paymentWay: paymentWay);
          }
          else{
            finishOnSiteOrder(orderId: orderId, report: report);
          }
        },
        error: (error) {
          setState(ResponseState<OrderModel>.error(error: error));
        }
      );
    });

    // response.whenOrNull(success: (data) {
    //   setState(ResponseState<OrderModel>.success(data: data));
    // }, error: (error) {
    //   setState(ResponseState<OrderModel>.error(error: error));
    // });
  }

  Future<void> updateAmount({required int orderId ,required String? amount}) async{

    setState(const ResponseState<OrderModel>.loading());

    final response = await ordersRepository.update(
      orderId: orderId,
      data: {
        "amount" : amount,
      },
    );

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> updateOrderType({required int orderId ,required int? type}) async{

    setState(const ResponseState<OrderModel>.loading());

    final response = await ordersRepository.update(
      orderId: orderId,
      data: {
        "type" : type,
      },
    );

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> sendInvoice({required int orderId}) async{

    setState(const ResponseState<OrderModel>.loading());

    final response = await ordersRepository.sendInvoice(endPoint: 'orders/send-invoice/$orderId');

    response.whenOrNull(success: (data) {
      setState(const ResponseState<OrderModel>.success(data: {'send_invoice' : true}));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> finishPickUpOrder({required int orderId , required String report , required int orderMode , required int paymentWay}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    Map data = {
      "status" : orderMode == 1 ? 3 : 4,
      'report' : report
    };

    if(orderMode != 1){
      data['payment_way'] = paymentWay;
    }

    final response = await ordersRepository.update(
        orderId: orderId,
        data: {
          "status" : orderMode == 1 ? 3 : 4,
          'report' : report
        },
    );

    response.whenOrNull(success: (data) {
      setState(const ResponseState<OrderModel>.success(data: {'finish_pickup_order' : true}));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> finishOnSiteOrder({required int orderId , required String report}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.update(
      orderId: orderId,
      data: {
        "status" : 4,
        'report' : report
      },
    );

    response.whenOrNull(success: (data) {
      setState(const ResponseState<OrderModel>.success(data: {'finish_pickup_order' : true}));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> finishDropOffOrder({required int orderId , required int? paymentWay}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.update(
      orderId: orderId,
      data: {
        "status" : 4,
      },
    );

    response.whenOrNull(success: (data) {
      setState(const ResponseState<OrderModel>.success(data: {'finish_drop_off_order' : true}));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> cancelOrder ({required int orderId}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.create(endPoint: 'orders/cancel/$orderId');

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> addItem({required int orderId ,required String title, required String quantity , required String price}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    Map data = {
      "title" : title,
      "quantity" : quantity,
      "price" : price
    };

    final response = await ordersRepository.addItem(orderId: orderId, data: data);

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  Future<void> deleteItem({required int orderId ,required int? itemId}) async{

    setState(const ResponseState<OrderModel>.loading());

    await Future.delayed(const Duration(seconds: 1));

    final response = await ordersRepository.deleteItem(orderId: orderId, itemId: itemId);

    response.whenOrNull(success: (data) {
      setState(ResponseState<OrderModel>.success(data: data));
    }, error: (error) {
      setState(ResponseState<OrderModel>.error(error: error));
    });
  }

  setState(ResponseState<OrderModel> newState){
    if(mounted) {
      state = newState;
    }
  }

}