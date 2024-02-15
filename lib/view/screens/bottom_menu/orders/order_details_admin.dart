import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:global_reparaturservice/view/screens/bottom_menu/orders/new_drop_off_order.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';
import 'package:global_reparaturservice/view_model/load_one_order_view_model.dart';
import 'package:global_reparaturservice/view_model/orders_view_model.dart';
import 'package:jiffy/jiffy.dart';

import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/providers/added_items_to_order.dart';
import '../../../../models/order.dart';
import '../../../../models/response_state.dart';
import '../../../../view_model/order_view_model.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/custsomer_card_new_order.dart';
import '../../../widgets/empty_widget.dart';
import '../../../widgets/gradient_background.dart';

class OrderDetailsAdmin extends ConsumerStatefulWidget {
  const OrderDetailsAdmin({super.key, required this.orderId});

  final int orderId;

  @override
  ConsumerState createState() => _OrderDetailsAdminState(orderId: orderId);
}

class _OrderDetailsAdminState extends ConsumerState<OrderDetailsAdmin> {
  _OrderDetailsAdminState({required this.orderId});

  final int orderId;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  OrderModel? globalOrderModel;

  @override
  void initState() {
    Future.microtask(() => ref.read(loadOrderViewModelProvider.notifier).loadOne(orderId: orderId));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ResponseState<OrderModel>>(orderViewModelProvider,
        (previous, next) {
      next.whenOrNull(
        success: (order) {

          ref.read(todayOrdersViewModelProvider.notifier).loadAll(today: true);
          ref.read(ordersViewModelProvider.notifier).loadAll();

          if(order?['send_invoice'] == true){
            AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.rightSlide,
                title: 'Invoice'.tr(),
                desc: 'Successfully send invoice to customer'.tr(),
                autoDismiss: false,
                dialogBackgroundColor: Colors.white,
                btnOk: CustomButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  radius: 10,
                  text: 'Ok'.tr(),
                  textColor: Colors.white,
                  bgColor: Theme.of(context).primaryColor,
                  height: 40,
                ),
                onDismissCallback: (dismiss) {})
                .show();
          }
          else{
            ref.read(loadOrderViewModelProvider.notifier).loadOne(orderId: orderId);
          }
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const GradientBackgroundWidget(),
            Column(
              children: [
                CustomAppBar(
                  title: 'order_details'.tr(),
                ),
                ref.watch(loadOrderViewModelProvider).maybeWhen(
                      loading: () => Expanded(
                        child: Center(
                          child: Lottie.asset(
                              'assets/images/global_loader.json',
                              height: 50),
                        ),
                      ),
                      data: (orderModel) {
                        if (_refreshController.isRefresh) {
                          _refreshController.refreshCompleted();
                        }

                        globalOrderModel = orderModel;

                        return ref.watch(orderViewModelProvider).maybeWhen(
                          loading: () => Expanded(
                            child: Center(
                              child: Lottie.asset(
                                  'assets/images/global_loader.json',
                                  height: 50),
                            ),
                          ),
                          orElse: (){
                            return OrderDetailsAdminView(orderModel: globalOrderModel!,);
                          },
                        );
                      },
                      success: (order){
                        return ref.watch(orderViewModelProvider).maybeWhen(
                          orElse: (){
                            return OrderDetailsAdminView(orderModel: globalOrderModel!,);
                          },
                        );
                      },
                      error: (error) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: CustomError(
                              message: error.errorMessage ?? '',
                              onRetry: () {
                                ref
                                    .read(loadOrderViewModelProvider.notifier)
                                    .loadOne(orderId: orderId);
                              },
                            ),
                          ),
                        ),
                      ),
                      orElse: () => Center(
                        child: CustomError(
                          message: 'unknown_error_please_try_again'.tr(),
                          onRetry: () {
                            ref
                                .read(loadOrderViewModelProvider.notifier)
                                .loadOne(orderId: orderId);
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

class OrderDetailsAdminView extends ConsumerWidget {
  OrderDetailsAdminView({super.key ,required this.orderModel});

  final OrderModel orderModel;


  static TextEditingController title = TextEditingController();
  static TextEditingController price = TextEditingController();
  static TextEditingController quantity = TextEditingController();

  static final GlobalKey<FormState> _reportFormKey = GlobalKey<FormState>();

  final RefreshController refreshController = RefreshController(initialRefresh: false);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: SizedBox(
        width: screenWidth * 95,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmartRefresher(
            controller: refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: () async {
              ref
                  .read(loadOrderViewModelProvider.notifier)
                  .loadOne(orderId: orderModel.id);
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Visit Time'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                          Jiffy.parse(orderModel.visitTime ?? '').format(pattern: 'dd.MM.yyyy : HH:mm'),
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor,
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Order reference'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SelectionArea(
                          child: AutoSizeText(
                            orderModel.referenceNo,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomerCardNewOrder(
                    userModel: orderModel.customer,
                    isOrderDetails: true,
                    empty: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'order_address'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                          orderModel.address,
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(color: Theme.of(context).primaryColor,height: 1,thickness: .5,),
                        const SizedBox(
                          height: 10,
                        ),
                        AutoSizeText(
                          'floor_number'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight:
                            FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                          '${orderModel.floorNumber ?? 'N/A'}',
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor,
                            fontSize: 15,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'order_status'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight:
                            FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                          orderModel.statusName,
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor,
                            fontSize: 15,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'problem_summary'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                          orderModel.problemSummary,
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor,
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border:
                        Border.all(color: const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'maintenance_device'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                          orderModel.maintenanceDevice,
                          style: TextStyle(
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'brand'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                          orderModel.brand,
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor,
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
                  if(orderModel.orderPhoneNumber != null)
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(8),
                              border: Border.all(
                                  color:
                                  const Color(0xffDCDCDC))),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    'order_phone'.tr(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  AutoSizeText(
                                    '${orderModel.orderPhoneNumber}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              Center(
                                child: Container(
                                  width: 90,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius:
                                      BorderRadius.circular(
                                          20)),
                                  child: IconButton(
                                    onPressed: () {},
                                    color: Theme.of(context)
                                        .primaryColor,
                                    icon: const Icon(
                                        Icons.call_rounded),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  const SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Order Type'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                          orderModel.typeName,
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Information'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                          orderModel.information ?? 'N/A',
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border:
                        Border.all(color: const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Services'.tr(),
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Table(
                              border: TableBorder.all(),
                              columnWidths: {
                                0: FlexColumnWidth(2.8),
                                1: FlexColumnWidth(1.3),
                                2: FlexColumnWidth(1.5),
                                if(orderModel.type != 3 && orderModel.status < 4)
                                3: FlexColumnWidth(1.1),
                              },
                              children: [
                                TableRow(
                                  children: <Widget>[
                                    TableCell(
                                      verticalAlignment:
                                      TableCellVerticalAlignment
                                          .top,
                                      child: Container(
                                        padding:
                                        const EdgeInsets.all(10),
                                        child: AutoSizeText(
                                          'Service'.tr(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 13,
                                              fontWeight:
                                              FontWeight.bold,
                                              overflow: TextOverflow
                                                  .ellipsis),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                      TableCellVerticalAlignment
                                          .top,
                                      child: Container(
                                        padding:
                                        const EdgeInsets.all(10),
                                        child: AutoSizeText(
                                          'Anzahl'.tr(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 13,
                                              fontWeight:
                                              FontWeight.bold,
                                              overflow: TextOverflow
                                                  .ellipsis),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                      TableCellVerticalAlignment
                                          .top,
                                      child: Container(
                                        padding:
                                        const EdgeInsets.all(10),
                                        child: AutoSizeText(
                                          'Price'.tr(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 13,
                                              fontWeight:
                                              FontWeight.bold,
                                              overflow: TextOverflow
                                                  .ellipsis),
                                        ),
                                      ),
                                    ),
                                    if(orderModel.type != 3 && orderModel.status < 4)
                                      TableCell(
                                        verticalAlignment:
                                        TableCellVerticalAlignment
                                            .top,
                                        child: Container(
                                          padding:
                                          const EdgeInsets.all(10),
// child: AutoSizeText(
//   'Endpreis'.tr(),
//   style: TextStyle(
//       color: Theme.of(context).primaryColor,
//       fontSize: 15,
//       fontWeight: FontWeight.bold,
//       overflow: TextOverflow.ellipsis
//   ),
// ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            Table(
                              border: TableBorder.all(),
                              columnWidths: {
                                0: FlexColumnWidth(2.8),
                                1: FlexColumnWidth(1.3),
                                2: FlexColumnWidth(1.5),
                                if(orderModel.type != 3 && orderModel.status < 4)
                                3: FlexColumnWidth(1.1),
                              },
                              children: orderModel.items?.map((e) {
                                return TableRow(
                                  children: <Widget>[
                                    TableCell(
                                      verticalAlignment:
                                      TableCellVerticalAlignment
                                          .top,
                                      child: Container(
                                        padding:
                                        const EdgeInsets.all(
                                            10),
                                        child: AutoSizeText(
                                          e.title,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                      TableCellVerticalAlignment
                                          .top,
                                      child: Container(
                                        padding:
                                        const EdgeInsets.all(
                                            10),
                                        child: AutoSizeText(
                                          '${e.quantity}',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 14,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      verticalAlignment:
                                      TableCellVerticalAlignment
                                          .top,
                                      child: Container(
                                        padding:
                                        const EdgeInsets.all(
                                            10),
                                        child: AutoSizeText(
                                          '${e.price}',
                                          style: TextStyle(
                                              color:
                                              Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.bold,
                                              overflow: TextOverflow
                                                  .ellipsis),
                                        ),
                                      ),
                                    ),
                                    if(orderModel.type != 3 && orderModel.status < 4)
                                      TableCell(
                                        verticalAlignment:
                                        TableCellVerticalAlignment
                                            .top,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              10),
                                          child: InkWell(
                                            onTap: () {
                                              ref
                                                  .read(
                                                  orderViewModelProvider
                                                      .notifier)
                                                  .deleteItem(
                                                  orderId:
                                                  orderModel
                                                      .id,
                                                  itemId: e.id);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      5)),
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 5,
                                                  vertical: 10),
                                              child: const Icon(
                                                Icons.delete_forever,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }).toList() ??
                                  [],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (orderModel.status == 3)
                              CustomButton(
                                  onPressed: () {
                                    AwesomeDialog(
                                        context: context,
                                        dialogType:
                                        DialogType.noHeader,
                                        animType:
                                        AnimType.rightSlide,
                                        autoDismiss: false,
                                        dialogBackgroundColor:
                                        Colors.white,
                                        body: Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 6,
                                              vertical: 12),
                                          child:
                                          SingleChildScrollView(
                                            child: Form(
                                              key: _reportFormKey,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      AutoSizeText(
                                                        'Add New Service'
                                                            .tr(),
                                                        style: TextStyle(
                                                            color: Theme.of(context)
                                                                .primaryColor,
                                                            fontSize:
                                                            17,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            overflow:
                                                            TextOverflow.ellipsis),
                                                      ),
                                                      IconButton(
                                                          onPressed:
                                                              () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon:
                                                          Icon(
                                                            Icons
                                                                .close,
                                                            size:
                                                            30,
                                                            color: Colors
                                                                .grey
                                                                .shade800,
                                                          ))
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  CustomTextFormField(
                                                      controller:
                                                      title,
                                                      label:
                                                      'Service'
                                                          .tr(),
                                                      height: 100,
                                                      validator:
                                                          (text) {
                                                        if (text?.isEmpty ??
                                                            true) {
                                                          return 'this_filed_required'
                                                              .tr();
                                                        }
                                                        return null;
                                                      }),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  CustomTextFormField(
                                                      controller:
                                                      quantity,
                                                      textInputType: TextInputType.number,
                                                      maxLength: 3,
                                                      label: 'Anzahl'
                                                          .tr(),
                                                      height: 60,
                                                      validator:
                                                          (text) {
                                                        if (text?.isEmpty ??
                                                            true) {
                                                          return 'this_filed_required'
                                                              .tr();
                                                        }
                                                        return null;
                                                      }),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  CustomTextFormField(
                                                      controller:
                                                      price,
                                                      textInputType:
                                                      TextInputType
                                                          .number,
                                                      label:
                                                      'Price'
                                                          .tr(),
                                                      height: 60,
                                                      validator:
                                                          (text) {
                                                        if (text?.isEmpty ??
                                                            true) {
                                                          return 'this_filed_required'
                                                              .tr();
                                                        }
                                                        return null;
                                                      }),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  CustomButton(
                                                      onPressed:
                                                          () {
                                                        if (_reportFormKey
                                                            .currentState
                                                            ?.validate() ??
                                                            false) {
                                                          Navigator.pop(
                                                              context);
                                                          ref.read(orderViewModelProvider.notifier).addItem(orderId: orderModel.id, title: title.text, quantity: quantity.text, price: price.text);
                                                          title.clear();
                                                          quantity.clear();
                                                          price.clear();
                                                        }
                                                      },
                                                      text: "Add"
                                                          .tr(),
                                                      radius: 10,
                                                      height: 50,
                                                      textColor:
                                                      Colors
                                                          .white,
                                                      bgColor: Theme.of(
                                                          context)
                                                          .primaryColor)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        onDismissCallback:
                                            (dismiss) {})
                                        .show();
                                  },
                                  text: 'Add Service'.tr(),
                                  textColor: Colors.white,
                                  radius: 10,
                                  height: 45,
                                  bgColor:
                                  Theme.of(context).primaryColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                '${'Netto Gesamt'.tr()} : ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: AutoSizeText(
                                '${orderModel.subtotal ?? 0.00} €',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                '${'19% MwSt.'.tr()} : ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: AutoSizeText(
                                '${orderModel.vat ?? 0.00} €',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                '${'*Endbetrag'.tr()} : ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: AutoSizeText(
                                '${orderModel.total ?? 0.00} €',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Anzahlung in Höhe von €'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                          '${orderModel.paidAmount ?? 0.00} €',
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Reparatur genehmigt bis €'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        AutoSizeText(
                            '${orderModel.maxMaintenancePrice ?? 'N/A'}',
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor,
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(8),
                        border: Border.all(
                            color:
                            const Color(0xffDCDCDC))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Files'.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        orderModel.files?.isEmpty ?? true
                            ? Center(
                            child: Padding(
                              padding:
                              const EdgeInsets.all(
                                  8.0),
                              child: Center(
                                  child: EmptyWidget(
                                    text: 'no_files'.tr(),
                                    height: 20,
                                    showImage: false,
                                    textSize: 14,
                                    )),
                            ))
                            : ListView.builder(
                          itemCount: orderModel
                              .files?.length,
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          itemBuilder:
                              (context, index) {
                            return Container(
                                height: 50,
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: AutoSizeText(
                                          orderModel
                                              .files?[
                                          index]
                                              .fileName ??
                                              'file_name'
                                                  .tr(),
                                          style: TextStyle(
                                              color: Theme.of(
                                                  context)
                                                  .primaryColor,
                                              fontSize:
                                              14,
                                              fontWeight:
                                              FontWeight
                                                  .bold),
                                        ),
                                      ),
                                      // Expanded(
                                      //   flex: 1,
                                      //   child: IconButton(
                                      //       onPressed:
                                      //           () {},
                                      //       icon: Icon(
                                      //         Icons
                                      //             .remove_red_eye_rounded,
                                      //         color: Theme.of(
                                      //                 context)
                                      //             .primaryColor,
                                      //       )),
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                            onPressed: () async {
                              Uri url = Uri.parse(orderModel.pdfLink);//order pdf file
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            text: 'Show file'.tr(),
                            textColor: Colors.white,
                            bgColor: Theme.of(context).primaryColor),
                      ),
                      // const SizedBox(
                      //   width: 5,
                      // ),
                      // Expanded(
                      //   child: CustomButton(
                      //       onPressed: () {},
                      //       text: 'Print file'.tr(),
                      //       textColor: Colors.white,
                      //       bgColor: Theme.of(context).primaryColor
                      //   ),
                      // )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if(orderModel.status != 0)
                    Column(
                      children: [
                        if(orderModel.status == 3)
                          Column(
                            children: [
                              CustomButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewDropOffOrder(orderModel: orderModel,)));
                              }, text: 'Finish & Make Drop Off Order'.tr(), textColor: Colors.white, bgColor: Theme.of(context).primaryColor),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        // if(orderModel.type != 3 && orderModel.status < 4)
                        // CustomButton(onPressed: (){
                        //   AwesomeDialog(
                        //       context: context,
                        //       dialogType: DialogType.question,
                        //       animType: AnimType.rightSlide,
                        //       title: 'Cancel Order'.tr(),
                        //       desc: 'Are you sure you want to cancel this order'.tr(),
                        //       autoDismiss: false,
                        //       dialogBackgroundColor: Colors.white,
                        //       btnCancel: CustomButton(
                        //         onPressed: () {
                        //           Navigator.of(context).pop();
                        //         },
                        //         radius: 10,
                        //         text: 'No'.tr(),
                        //         textColor: Colors.white,
                        //         bgColor: const Color(0xffd63d46),
                        //         height: 40,
                        //       ),
                        //       btnOk: CustomButton(
                        //         onPressed: () {
                        //           Navigator.of(context).pop();
                        //           ref.read(orderViewModelProvider.notifier).cancelOrder(orderId: orderModel.id);
                        //         },
                        //         radius: 10,
                        //         text: 'Yes'.tr(),
                        //         textColor: Colors.white,
                        //         bgColor: Theme.of(context).primaryColor,
                        //         height: 40,
                        //       ),
                        //       onDismissCallback: (dismiss) {})
                        //       .show();
                        // }, text: 'Cancel Order'.tr(), textColor: Colors.white, bgColor: Colors.redAccent),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
