import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';

import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

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

  late TextEditingController amount;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  OrderModel? globalOrderModel;

  @override
  void initState() {
    Future.microtask(() =>
        ref.read(orderViewModelProvider.notifier).loadOne(orderId: orderId));

    amount = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ResponseState<OrderModel>>(orderViewModelProvider,
        (previous, next) {
      next.whenOrNull(
        success: (order) {

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
            amount.clear();
            ref.read(orderViewModelProvider.notifier).loadOne(orderId: orderId);
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
                ref.watch(orderViewModelProvider).maybeWhen(
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

                        return Expanded(
                          child: SizedBox(
                            width: screenWidth * 95,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SmartRefresher(
                                controller: _refreshController,
                                enablePullDown: true,
                                enablePullUp: false,
                                onRefresh: () async {
                                  ref
                                      .read(orderViewModelProvider.notifier)
                                      .loadOne(orderId: orderId);
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
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
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    'payment_status'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    orderModel.isPaid
                                                        ? 'paid'.tr()
                                                        : 'not_paid'.tr(),
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
                                              orderModel.description,
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
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
                                                    '${orderModel.floorNumber}',
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
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    'apartment_number'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    orderModel
                                                            .apartmentNumber ??
                                                        'N/A',
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
                                      if (orderModel.amount == 0)
                                        Column(
                                          children: [
                                            CustomTextFormField(
                                              label: 'New amount'.tr(),
                                              validator: (text) {},
                                              controller: amount,
                                              textInputType:
                                                  TextInputType.number,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 40,
                                              width: screenWidth * 80,
                                              child: CustomButton(
                                                  onPressed: () {
                                                    if (amount
                                                        .text.isNotEmpty) {
                                                      ref
                                                          .read(
                                                              orderViewModelProvider
                                                                  .notifier)
                                                          .updateAmount(
                                                              orderId: orderId,
                                                              amount:
                                                                  amount.text);
                                                    }
                                                  },
                                                  text: 'Update amount'.tr(),
                                                  textColor: Colors.white,
                                                  bgColor: Theme.of(context)
                                                      .primaryColor),
                                            )
                                          ],
                                        )
                                      else
                                        Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffDCDCDC))),
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    'last_updated_amount'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                     '${orderModel.amount}',
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
                                              height: 5,
                                            ),
                                            if (orderModel.isPaid == false && orderModel.status != 3)
                                              Column(
                                                children: [
                                                  CustomTextFormField(
                                                    label: 'New amount'.tr(),
                                                    validator: (text) {},
                                                    controller: amount,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                    width: screenWidth * 80,
                                                    child: CustomButton(
                                                        onPressed: () {
                                                          if (amount.text
                                                              .isNotEmpty) {
                                                            ref
                                                                .read(orderViewModelProvider
                                                                    .notifier)
                                                                .updateAmount(
                                                                    orderId:
                                                                        orderId,
                                                                    amount: amount
                                                                        .text);
                                                          }
                                                        },
                                                        text: 'Update amount'
                                                            .tr(),
                                                        textColor: Colors.white,
                                                        bgColor:
                                                            Theme.of(context)
                                                                .primaryColor),
                                                  )
                                                ],
                                              )
                                          ],
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
                                              'order_report'.tr(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            AutoSizeText(
                                              orderModel.report ??
                                                  'Not set'.tr(),
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
                                              'uploaded_files'.tr(),
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
                                                    child: SizedBox(
                                                        height: 230,
                                                        child: Center(
                                                            child: EmptyWidget(
                                                          text: 'no_files'.tr(),
                                                          height: 20,
                                                          textSize: 14,
                                                        ))),
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
                                                          height: 40,
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(1),
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                AutoSizeText(
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
                                                                IconButton(
                                                                    onPressed:
                                                                        () {},
                                                                    icon: Icon(
                                                                      Icons
                                                                          .remove_red_eye_rounded,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ))
                                                              ],
                                                            ),
                                                          ));
                                                    },
                                                  ),
                                          ],
                                        ),
                                      ),
                                      if(orderModel.amount != 0)
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CustomButton(
                                                  onPressed: () {
                                                    ref.read(orderViewModelProvider.notifier).sendInvoice(orderId: orderId);
                                                  },
                                                  text: 'Send invoice'.tr(),
                                                  textColor: Colors.white,
                                                  bgColor: Theme.of(context).primaryColor,
                                                  radius: 10,
                                                ),
                                              ),
                                              const SizedBox(width: 5,),
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
                                                  text: 'Show invoice'.tr(),
                                                  textColor: Colors.white,
                                                  bgColor: Theme.of(context).primaryColor,
                                                  radius: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      success: (order){
                        return Expanded(
                          child: SizedBox(
                            width: screenWidth * 95,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SmartRefresher(
                                controller: _refreshController,
                                enablePullDown: true,
                                enablePullUp: false,
                                onRefresh: () async {
                                  ref
                                      .read(orderViewModelProvider.notifier)
                                      .loadOne(orderId: orderId);
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
                                              'visit'.tr(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            AutoSizeText(
                                              globalOrderModel?.isVisit ?? false
                                                  ? 'second_visit'.tr()
                                                  : 'first_visit'.tr(),
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
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
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
                                                    '${globalOrderModel?.statusName}',
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
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    'payment_status'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    globalOrderModel?.isPaid ?? false
                                                        ? 'paid'.tr()
                                                        : 'not_paid'.tr(),
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
                                              '${globalOrderModel?.description}',
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
                                              'order_address'.tr(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            AutoSizeText(
                                              '${globalOrderModel?.address}',
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
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
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
                                                    '${globalOrderModel?.floorNumber}',
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
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    'apartment_number'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    globalOrderModel?.apartmentNumber ??
                                                        'N/A',
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
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomerCardNewOrder(
                                        userModel: globalOrderModel?.customer,
                                        isOrderDetails: true,
                                        empty: false,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if(globalOrderModel?.orderPhoneNumber != null)
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
                                                        '${globalOrderModel?.orderPhoneNumber}',
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
                                      if (globalOrderModel?.amount == 0)
                                        Column(
                                          children: [
                                            CustomTextFormField(
                                              label: 'New amount'.tr(),
                                              validator: (text) {},
                                              controller: amount,
                                              textInputType:
                                              TextInputType.number,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              height: 40,
                                              width: screenWidth * 80,
                                              child: CustomButton(
                                                  onPressed: () {
                                                    if (amount
                                                        .text.isNotEmpty) {
                                                      ref
                                                          .read(
                                                          orderViewModelProvider
                                                              .notifier)
                                                          .updateAmount(
                                                          orderId: orderId,
                                                          amount:
                                                          amount.text);
                                                    }
                                                  },
                                                  text: 'Update amount'.tr(),
                                                  textColor: Colors.white,
                                                  bgColor: Theme.of(context)
                                                      .primaryColor),
                                            )
                                          ],
                                        )
                                      else
                                        Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffDCDCDC))),
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    'last_updated_amount'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                    ),
                                                  ),
                                                  AutoSizeText(
                                                    '${globalOrderModel?.amount}',
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
                                              height: 5,
                                            ),
                                            if (globalOrderModel?.isPaid == false)
                                              Column(
                                                children: [
                                                  CustomTextFormField(
                                                    label: 'New amount'.tr(),
                                                    validator: (text) {},
                                                    controller: amount,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                    width: screenWidth * 80,
                                                    child: CustomButton(
                                                        onPressed: () {
                                                          if (amount.text
                                                              .isNotEmpty) {
                                                            ref
                                                                .read(orderViewModelProvider
                                                                .notifier)
                                                                .updateAmount(
                                                                orderId:
                                                                orderId,
                                                                amount: amount
                                                                    .text);
                                                          }
                                                        },
                                                        text: 'Update amount'
                                                            .tr(),
                                                        textColor: Colors.white,
                                                        bgColor:
                                                        Theme.of(context)
                                                            .primaryColor),
                                                  )
                                                ],
                                              )
                                          ],
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
                                              'order_report'.tr(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            AutoSizeText(
                                              globalOrderModel?.report ??
                                                  'Not set'.tr(),
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
                                              'uploaded_files'.tr(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            globalOrderModel?.files?.isEmpty ?? true
                                                ? Center(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      8.0),
                                                  child: SizedBox(
                                                      height: 230,
                                                      child: Center(
                                                          child: EmptyWidget(
                                                            text: 'no_files'.tr(),
                                                            height: 20,
                                                            textSize: 14,
                                                          ))),
                                                ))
                                                : ListView.builder(
                                              itemCount: globalOrderModel?.files?.length,
                                              shrinkWrap: true,
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (context, index) {
                                                return Container(
                                                    height: 40,
                                                    margin:
                                                    const EdgeInsets
                                                        .all(1),
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400))),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal:
                                                          5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          AutoSizeText(
                                                            globalOrderModel?.files?[
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
                                                          IconButton(
                                                              onPressed:
                                                                  () {},
                                                              icon: Icon(
                                                                Icons
                                                                    .remove_red_eye_rounded,
                                                                color: Theme.of(
                                                                    context)
                                                                    .primaryColor,
                                                              ))
                                                        ],
                                                      ),
                                                    ));
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      if(globalOrderModel?.amount != 0)
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            CustomButton(
                                              onPressed: () {
                                                ref.read(orderViewModelProvider.notifier).sendInvoice(orderId: orderId);
                                              },
                                              text: 'Send invoice to customer'.tr(),
                                              textColor: Colors.white,
                                              bgColor: Theme.of(context).primaryColor,
                                            ),
                                          ],
                                        ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                                    .read(orderViewModelProvider.notifier)
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
                                .read(orderViewModelProvider.notifier)
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
